# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Workflow::StepTest < ActiveSupport::TestCase
  test "kind must be in the ledger vocabulary" do
    step = workflow_steps(:royal_road_scans)
    step.kind = "marketing"
    assert_not step.valid?
    assert step.errors.of_kind?(:kind, :inclusion)
  end

  test "status must be in the vocabulary" do
    step = workflow_steps(:royal_road_scans)
    step.status = "blocked"
    assert_not step.valid?
    assert step.errors.of_kind?(:status, :inclusion)
  end

  test "one step per kind per project" do
    duplicate = workflow_projects(:royal_road).steps.new(kind: :scans, status: :todo)
    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:kind, :taken)
  end

  test "a todo step has no actor" do
    step = workflow_steps(:royal_road_transcription)
    assert_nil step.actor
    assert_predicate step, :valid?
  end

  test "skipped marks a step that will never apply" do
    assert_predicate workflow_steps(:royal_road_print_budget), :skipped?
  end
end
