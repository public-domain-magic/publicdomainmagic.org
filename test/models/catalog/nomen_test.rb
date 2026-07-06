# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Catalog::NomenTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert catalog_nomens(:boyce).valid?
  end

  test "requires a name" do
    nomen = Catalog::Nomen.new(agent: catalog_agents(:hugard), kind: "birth")
    assert_not nomen.valid?
    assert nomen.errors.of_kind?(:name, :blank)
  end

  test "requires an agent" do
    nomen = Catalog::Nomen.new(name: "A Name", kind: "birth")
    assert_not nomen.valid?
    assert nomen.errors.of_kind?(:agent, :blank)
  end

  test "kind must be a known value" do
    invalid = Catalog::Nomen.new(agent: catalog_agents(:hugard), name: "A Name", kind: "nickname")
    assert_not invalid.valid?
    assert invalid.errors.of_kind?(:kind, :inclusion)
  end
end
