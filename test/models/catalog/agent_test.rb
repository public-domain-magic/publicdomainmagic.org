# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::AgentTest < ActiveSupport::TestCase
  test "requires a name" do
    agent = Catalog::Agent.new(kind: "person")
    assert_not agent.valid?
    assert agent.errors.of_kind?(:name, :blank)
  end

  test "kind must be a known value" do
    assert Catalog::Agent.new(name: "Someone", kind: "person").valid?

    invalid = Catalog::Agent.new(name: "Someone", kind: "deity")
    assert_not invalid.valid?
    assert invalid.errors.of_kind?(:kind, :inclusion)
  end

  test "has many nomens" do
    assert_equal 4, catalog_agents(:hugard).nomens.count
  end

  test "kind predicates" do
    assert catalog_agents(:harper_brothers).corporate_body?
    assert catalog_agents(:hugard).person?
  end
end
