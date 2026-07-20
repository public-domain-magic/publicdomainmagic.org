# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# One book's journey to publication: a step ledger over a Catalog work.
# "How far it goes" is which steps are done; nothing blocks anything except
# real dependencies, expressed as advisory predicates rather than DB
# constraints, because the owner deliberately iterates out of order. A
# brand-new book can enter the system and simply wait out its copyright
# term (the countdown lives in the Copyright context).
class Workflow::Project < ApplicationRecord
  belongs_to :work, class_name: "Catalog::Work"
  belongs_to :lead, class_name: "User"
  # The PDM ebook edition this pipeline produces, once it exists.
  belongs_to :edition_manifestation, class_name: "Catalog::Manifestation", optional: true

  # The ledger, with its write API ({StepsExtension}): steps are addressed
  # by kind, and completing one records who did it and when.
  has_many :steps, dependent: :destroy, extend: StepsExtension
  has_many :resources, dependent: :destroy

  validates :work_id, uniqueness: true

  # Starts tracking a work: creates the project and seeds the ledger with
  # one todo step per kind, so progress is always a matter of updating —
  # never wondering which rows exist.
  def self.start(work:, lead:)
    transaction do
      create!(work:, lead:).tap do |project|
        Workflow::Step::KINDS.each { |kind| project.steps.create!(kind:, status: :todo) }
      end
    end
  end

  # Whether the book can be downloaded: the PG→Standard-Ebooks text pipeline
  # (the ONE step) has run to completion.
  def downloadable?
    steps[:text_pipeline].done?
  end

  # Whether the book is live on PublicDomainMagic.org.
  def published?
    steps[:publication].done?
  end

  # Advisory dependency predicate (no hard gate): the text is ready and the
  # copyright question is settled — either the clearance step is done or the
  # Copyright context has determined the work public domain.
  def ready_to_publish?
    downloadable? && (steps[:copyright_clearance].done? || determination_public_domain?)
  end

  # Reads the Copyright seam lazily: the unscoped determination for this
  # work, if any. A read, not a callback across contexts.
  private def determination_public_domain?
    determination = Copyright::Determination.find_by(work_id:, manifestation_id: nil)
    !determination.nil? && determination.public_domain?
  end
end
