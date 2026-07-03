# Testing recipes (load when you need one)

## Active Storage & Action Text fixtures

Rails has no generator for these — wire them by hand.

```yaml
# test/fixtures/active_storage/blobs.yml
reading_image_blob: <%= ActiveStorage::FixtureSet.blob filename: "reading.webp", service_name: "test" %>

# test/fixtures/active_storage/attachments.yml
reading_image:
  name: image
  record: reading (Picture)        # label (Type) polymorphic join
  blob: reading_image_blob
```

File payloads live in `test/fixtures/files/`; the `:test` storage service (a temp dir) holds bytes.
For an upload in a test, use `fixture_file_upload("white-rabbit.webp", "image/webp")`. Action Text
bodies are fixtures too — `action_text/rich_texts.yml` (Trix/HTML apps) or `action_text/markdowns.yml`
(writebook's Markdown) — with `record: welcome (Page)` back-references. So one logical "page with body + image" is several fixture
rows across files, wired by label — the reason the corpus is kept deliberately tiny.
`refs/writebook/test/fixtures/`, `refs/upright/test/fixtures/active_storage/`.

## System-test helper set

`ApplicationSystemTestCase` is `driven_by :selenium, using: :headless_chrome`. Encode the flaky-async
knowledge once in `SystemTestHelper`:

- A browser `sign_in(email, password = "secret123456")` that fills the real form (different
  signature from the integration helper, same password).
- `wait_for_cable_connection` — assert a `turbo-cable-stream-source[connected]` is present before
  acting on real-time UI.
- Driving a custom-element editor Capybara can't `fill_in`: set its value via `execute_script`
  (pull in `ActionView::Helpers::JavaScriptHelper` for `escape_javascript`).

`refs/writebook/test/test_helpers/system_test_helper.rb`,
`refs/once-campfire/test/test_helpers/system_test_helper.rb`.

## Multi-actor real-time tests

Drive two users in one browser test with Capybara's `using_session`, and assert one sees the other's
broadcast — the canonical reason a system test earns its place:

```ruby
using_session("second user") do
  visit project_url(project)
  assert_text "Is this thing on?"   # pushed by the first user's action
end
```

`refs/once-campfire/test/system/sending_messages_test.rb`, `refs/writebook/test/system/`.

## Channel & helper tests

- **Connection auth:** `ActionCable::Connection::TestCase` — start a real session, set the signed
  cookie, `connect`, assert `connection.current_user`; `assert_reject_connection` for the no-cookie
  case (writebook, campfire).
- **Channel authorization:** reject a non-member subscription with `ActionCable::Channel::TestCase`
  (`subscription.rejected?` / `assert_has_stream_for`) — tested at the channel, not a controller
  (campfire's `presence_channel_test.rb`).
- **Helper:** `ActionView::TestCase` to call view helpers directly (e.g. a sanitizer helper).

`refs/writebook/test/channels/application_cable/connection_test.rb`,
`refs/once-campfire/test/channels/presence_channel_test.rb`.

## CI shape

`bin/ci` runs lint + security + audit before the suite. fizzy runs the full roster — Rubocop,
bundler-audit, importmap audit, Brakeman, Gitleaks (secret scan) — then `bin/rails test`, then
system tests separately at `PARALLEL_WORKERS=1`, and runs the **whole suite once per DB adapter**.
upright's is leaner (Rubocop, Brakeman, actionlint, zizmor, then tests). Match the roster to your
app. `refs/fizzy/config/ci.rb`, `refs/upright/config/ci.rb`.

## UUID-PK fixtures (only if you adopt UUIDv7 primary keys)

Fixture ordering and "runtime records are newer than fixtures" both break under UUID PKs. If you go
that route, you need a helper prepended onto `ActiveRecord::FixtureSet` that derives a stable,
time-ordered UUIDv7 from each fixture label (same CRC32 the integer path uses). Skip entirely on
integer PKs. `refs/fizzy/test/test_helper.rb`.
