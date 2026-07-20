# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Workflow::ProjectTest < ActiveSupport::TestCase
  test "start creates the project and seeds the full ledger in todo" do
    project = Workflow::Project.start(work: catalog_works(:trick_brain), lead: users(:kerrick))

    assert_predicate project, :persisted?
    assert_equal users(:kerrick), project.lead
    assert_equal Workflow::Step::KINDS.sort, project.steps.pluck(:kind).sort
    assert project.steps.all?(&:todo?)
  end

  test "start is one project per work" do
    Workflow::Project.start(work: catalog_works(:trick_brain), lead: users(:kerrick))

    assert_raises ActiveRecord::RecordInvalid do
      Workflow::Project.start(work: catalog_works(:trick_brain), lead: users(:kerrick))
    end
  end

  test "steps are addressed by kind" do
    assert_equal workflow_steps(:royal_road_scans),
      workflow_projects(:royal_road).steps[:scans]
  end

  test "completing a step records status, actor, and date" do
    travel_to Date.new(2026, 7, 19) do
      workflow_projects(:royal_road).steps.complete(
        :scans, by: users(:kerrick), note: "Scanned at 600dpi.")
    end

    step = workflow_steps(:royal_road_scans).reload
    assert_predicate step, :done?
    assert_equal users(:kerrick), step.actor
    assert_equal Date.new(2026, 7, 19), step.happened_on
    assert_equal "Scanned at 600dpi.", step.note
  end

  test "completing a step twice is idempotent-safe" do
    steps = workflow_projects(:royal_road).steps
    steps.complete(:scans, by: users(:kerrick))
    steps.complete(:scans, by: users(:kerrick))

    assert_predicate workflow_steps(:royal_road_scans).reload, :done?
  end

  test "downloadable? flips when the text pipeline completes" do
    project = workflow_projects(:royal_road)
    assert_not project.downloadable?

    project.steps.complete(:text_pipeline, by: users(:kerrick))
    assert_predicate project, :downloadable?
  end

  test "published? reads the publication step" do
    project = workflow_projects(:royal_road)
    assert_not project.published?

    project.steps.complete(:publication, by: users(:kerrick))
    assert_predicate project, :published?
  end

  test "ready_to_publish? needs the text and a settled copyright question" do
    project = workflow_projects(:royal_road)
    assert_not project.ready_to_publish?

    project.steps.complete(:text_pipeline, by: users(:kerrick))
    assert_predicate project, :ready_to_publish?
  end

  test "a public domain determination settles copyright without the clearance step" do
    project = workflow_projects(:royal_road)
    workflow_steps(:royal_road_copyright_clearance).update!(status: :todo)
    project.steps.complete(:text_pipeline, by: users(:kerrick))

    assert_predicate project, :ready_to_publish?
  end

  test "a future public domain date does not settle the copyright question" do
    project = workflow_projects(:greater_magic)
    project.steps.complete(:text_pipeline, by: users(:kerrick))

    travel_to Date.new(2030, 1, 1) do
      assert_not project.ready_to_publish?
    end
    travel_to Date.new(2034, 1, 1) do
      assert_predicate project, :ready_to_publish?
    end
  end
end
