---
name: rails-37signals-testing
description: >
  Use when writing or organizing tests for a Rails app built the 37signals / Omakase way:
  model, controller/integration, system, channel, and helper tests, plus fixtures and test
  helpers. Covers Minitest + fixtures (never RSpec or FactoryBot), authenticating tests via a
  real login (never mocking current_user), mocking only at the network boundary, keeping system
  tests few and pushing coverage down to fast layers, asserting Turbo broadcasts without a
  browser, and parallelization. Trigger when the user says "write a test," "add test coverage,"
  "set up a factory/fixture," "test this controller/model/feature," or "why is this test flaky."
  Do NOT use for non-test code. Do NOT introduce rspec, factory_bot, shoulda, or database_cleaner.
---

# Testing, the 37signals way

The Rails-omakase default, taken seriously: **Minitest + YAML fixtures**. No RSpec, no
FactoryBot, no shoulda, no database_cleaner, no spec DSL. If you came expecting
`describe`/`it`/`let`/`create(:user)`, recalibrate — these are the deltas that matter.

Examples use a neutral `Post`/`Project`/`User` domain. `refs/` (`writebook`, `once-campfire`,
`fizzy`, `upright`) is ground truth — **lift the mechanism, translate the noun.** The cleanest
reference is `refs/writebook/test/`.

## The three load-bearing lines

```ruby
# test/test_helper.rb
module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all
    include SessionTestHelper
  end
end
```

- **`parallelize(workers: :number_of_processors)`** — one worker per core, isolated DB each; tests
  must not depend on each other. (System tests can't parallelize — force `PARALLEL_WORKERS=1` in CI.)
- **`fixtures :all`** — loads every fixture once; each test runs in a transaction rolled back after.
- A small auth helper mixed into every test (below).

## Fixtures, not factories

There are no factories. Tests reference a fixed cast by **label**; Rails resolves the label to the
foreign key at load time:

```yaml
# test/fixtures/accesses.yml
david_handbook:
  user: david        # → users(:david).id
  project: handbook  # → projects(:handbook).id
  level: editor
```

Every test sees the same knowable world (`users(:david)` is an admin everywhere). When a test needs
a variant, **mutate a fixture in-test** (`projects(:manual).update!(published: true)`) rather than
adding a near-duplicate fixture or a factory.

Fixtures are **ERB-evaluated** — compute a shared bcrypt digest once and reuse it, so the test
password is a known constant:

```yaml
# test/fixtures/users.yml
<% password_digest = BCrypt::Password.create("secret123456") %>
david:
  email_address: david@example.com
  password_digest: <%= password_digest %>
  role: administrator
```

Polymorphic and rich-content fixtures use the `label (Type)` syntax (`record: welcome (Page)`), and
Action Text / Active Storage are fixtured the same way (ActionText bodies in
`fixtures/action_text/*.yml`; blobs via `ActiveStorage::FixtureSet.blob`). `refs/writebook/test/fixtures/`.

## Auth in tests: a real login, never a `current_user` stub

Authentication is real-but-cheap. **Do not mock `current_user`; never set `Current` by hand.** A
helper performs an actual login over HTTP and asserts the cookie; the app's own middleware then
populates `Current` from it.

```ruby
# test/test_helpers/session_test_helper.rb
def sign_in(user)
  user = users(user) unless user.is_a?(User)
  post session_url, params: { email_address: user.email_address, password: "secret123456" }
  assert cookies[:session_token].present?
end
```

That shared `secret123456` (from the fixture ERB above) is the linchpin. Tests then run as that
user with no further setup (`setup { sign_in :david }`). **System tests need a *different*
`sign_in`** (same name, different signature) that drives the actual form, because there's no test
request object in a browser. `refs/writebook/test/test_helpers/session_test_helper.rb`,
`refs/once-campfire/test/test_helpers/`.

Keep cross-cutting helpers as **small named modules** under `test/test_helpers/`, mixed into the
base case — not a `spec/support/**` autoload junk drawer.

## Mock only at the network boundary

Real objects everywhere except the wire. Load `webmock/minitest` and `disable_net_connect!` so no
test hits the network by accident; stub outbound HTTP with WebMock and assert on request shape.
Reserve **Mocha** (`mocha/minitest`) for what you can't drive over HTTP — timeouts, DNS, sockets, a
collaborator *below* the wire:

```ruby
ApiClient.any_instance.stubs(:post).raises(Net::OpenTimeout)   # simulate a timeout
Resolv.stubs(:getaddress).returns("1.2.3.4", "127.0.0.1")      # prove no DNS rebinding
```

Security properties (SSRF guard, DNS rebinding) get dedicated tests with stubbed sockets. System
tests turn WebMock off (the browser stack needs loopback). `refs/once-campfire/test/`,
`refs/upright/test/`.

## Test pyramid: few system tests, lots of fast ones

System tests (Capybara + headless Selenium) are expensive — keep them **few**, reserved for flows
you can't prove without a browser (multi-user real-time, JS-heavy interactions); push everything
else down to fast model/controller/integration tests.

Base class signals the kind: `ActiveSupport::TestCase` (model/lib), `ActionDispatch::IntegrationTest`
(controller — they *are* integration tests here, driving real routes with `get root_url`),
`ApplicationSystemTestCase` (browser), `ActionView::TestCase` (helpers),
`ActionCable::Connection::TestCase` (channels). Per-file private helpers go at the bottom under
`private`; extract a shared module only when a second file needs it.

Control time with `travel_to`/`freeze_time` for date-dependent behavior — a common flake source
against a fixed fixture world. Run a single test with `bin/rails test test/models/post_test.rb:42`.

## Assert the broadcast, not the WebSocket

Most real-time behavior is verified in **fast request tests**, not the browser. Read what was
pushed to the Action Cable pubsub and assert on the parsed Turbo Stream — Rails ships
`assert_turbo_stream_broadcasts`; campfire wraps it in a project helper that also renders the payload:

```ruby
# refs/once-campfire/test/test_helpers/turbo_test_helper.rb
assert_rendered_turbo_stream_broadcast @project, :posts, action: "append", target: [ @project, :posts ] do
  assert_select ".post__body", text: /New one/
end
```

Jobs are **asserted, not run**: include `ActiveJob::TestHelper` and `assert_enqueued_jobs 1, only:
NotifyJob` (reach for `perform_enqueued_jobs` only when you're testing the job's own side effects).
`refs/once-campfire/test/test_helpers/turbo_test_helper.rb`, `refs/fizzy/test/`.

## See also

`references/recipes.md` for: ActiveStorage/Action Text fixture wiring, the system-test helper set
(waiting for cable, driving a custom editor via JS), multi-actor system tests (`using_session`),
and CI shape (lint/security/audit steps before tests).
