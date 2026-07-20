# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# The public book view: what can be found, what can be downloaded by whom,
# and what can be bought. One listing per book-level Catalog work; Magic adds
# presentation and access policy, never bibliographic data.
class Magic::Listing < ApplicationRecord
  # The access axis. +public+ = safe to expose to laypeople (early Tarbell);
  # +protected+ = exposes methods working magicians still rely on, grounded
  # in the joint 1993 I.B.M. & S.A.M. Code of Ethics, clause 1. This also
  # drives Workflow's print_budget step (public marketplaces carry only
  # +public+ titles).
  EXPOSURES = %w[public protected].freeze

  belongs_to :work, class_name: "Catalog::Work"

  has_many :purchase_links, -> { order(:position) },
    inverse_of: :listing, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  enum :exposure, EXPOSURES.index_by(&:itself), suffix: true, validate: true

  validates :work_id, uniqueness: true

  # The entire download gate: public listings are open to everyone
  # (including signed-out visitors); protected listings require a capability
  # (magician or librarian) from the Users seam.
  def accessible_to?(user)
    public_exposure? || (!user.nil? && user.can_access_protected?)
  end
end
