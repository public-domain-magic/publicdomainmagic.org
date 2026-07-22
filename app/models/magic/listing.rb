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

  # Browse order for the public library: featured titles first, then
  # alphabetically by work title (joined, so the sort is done in the database).
  scope :browsable, -> { left_outer_joins(:work).order(featured: :desc).order("catalog_works.title") }

  # Eager-load everything a book page renders across the Catalog seam, so the
  # detail view does not fan out into per-association queries. Uses +preload+
  # (separate queries) so it composes with +browsable+'s ordering join.
  scope :with_book_details, -> {
    preload(:tags, :purchase_links,
      work: [
        :form_of_work,
        :concepts,
        { contributions: :agent },
        { expressions: { manifestations: [:carrier, :series, { contributions: :agent }] } },
])
  }

  # Case-insensitive search across a book's title, its creators' names and
  # name variants, and its tags and bibliographic subjects. A blank query
  # matches everything. Deliberately a simple LIKE rather than full text: the
  # corpus is small, so the FTS5 index the models skill describes is not yet
  # worth its callback maintenance — that is the upgrade path as the library grows.
  scope :matching, -> (query) {
    cleaned = query.to_s.strip
    next all if cleaned.blank?

    pattern = "%#{cleaned.downcase}%"
    ids = [
      Magic::Listing.joins(:work).where("LOWER(catalog_works.title) LIKE ?", pattern),
      Magic::Listing.joins(work: :agents).where("LOWER(catalog_agents.name) LIKE ?", pattern),
      Magic::Listing.joins(work: { agents: :nomens }).where("LOWER(catalog_nomens.name) LIKE ?", pattern),
      Magic::Listing.joins(:tags).where("LOWER(magic_tags.name) LIKE ?", pattern),
      Magic::Listing.joins(work: :concepts).where("LOWER(catalog_concepts.name) LIKE ?", pattern),
    ].flat_map(&:ids)
    where(id: ids)
  }

  # The listings carrying a given tag — the tag page is just a filtered browse.
  scope :tagged_with, -> (tag) { joins(:taggings).where(magic_taggings: { tag_id: tag.id }) }

  # A slug of the id and the book's title for readable URLs. Lookups read only
  # the leading id (ActiveRecord casts it), so the title portion may drift as
  # the record is edited without breaking existing links.
  def to_param
    [id, work.title.to_s.parameterize].join("-")
  end

  # The entire download gate: public listings are open to everyone
  # (including signed-out visitors); protected listings require a capability
  # (magician or librarian) from the Users seam.
  def accessible_to?(user)
    public_exposure? || (!user.nil? && user.can_access_protected?)
  end
end
