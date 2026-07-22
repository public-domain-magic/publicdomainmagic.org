# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Seeds::LoaderTest < ActiveSupport::TestCase
  SEEDS = Rails.root.join("test/fixtures/files/seeds")
  INVALID_SEEDS = Rails.root.join("test/fixtures/files/seeds_invalid")

  test "loads a corpus through the model layer, resolving cross-context references" do
    assert_difference({
"Catalog::Work.count" => 1,
"Magic::Listing.count" => 1,
"Magic::Tag.count" => 1,
"Copyright::Determination.count" => 1,
}) do
      Seeds::Loader.new(root: SEEDS).load!
    end

    work = Catalog::Work.find_by!(title: "A Test Grimoire")
    assert_equal "Test Merlin", work.agents.sole.name
    assert_equal "Test Grimoire Form", work.form_of_work.name

    listing = Magic::Listing.find_by!(work:)
    assert_predicate listing, :public_exposure?
    assert_equal ["test-witchcraft"], listing.tags.map(&:name)
    assert Copyright::Determination.exists?(work:, manifestation_id: nil)
  end

  test "is idempotent — a second load creates nothing new" do
    Seeds::Loader.new(root: SEEDS).load!

    assert_no_difference [
      "Catalog::Work.count",
      "Magic::Listing.count",
      "Magic::Tag.count",
      "Catalog::Contribution.count",
      "Copyright::Determination.count",
] do
      Seeds::Loader.new(root: SEEDS).load!
    end
  end

  test "runs validations and rolls back on a malformed row" do
    assert_no_difference "Catalog::Agent.count" do
      assert_raises ActiveRecord::RecordInvalid do
        Seeds::Loader.new(root: INVALID_SEEDS).load!
      end
    end
  end
end
