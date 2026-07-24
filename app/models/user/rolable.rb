# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Authorization for a {User}, expressed as capabilities rather than raw role
# checks.
#
# Call sites ask +can_catalog?+, +can_access_protected?+, and friends — never
# +role?(:librarian)+ directly — so role implication lives in exactly one
# place. There are no implication chains: a person who needs several
# capabilities holds several explicit grants, keeping every capability
# traceable to an auditable {Role} row.
module User::Rolable
  extend ActiveSupport::Concern

  included do
    has_many :roles, dependent: :destroy # steep:ignore NoMethod
    has_many :granted_roles, class_name: "Role", foreign_key: :granted_by_id, # steep:ignore NoMethod
      inverse_of: :granted_by, dependent: :nullify
  end

  # Whether this user holds a grant for the named role. Prefer the capability
  # predicates below at call sites.
  def role?(name) = roles.exists?(name:)

  # Whether this user may grant and revoke roles (the Administrator role).
  def can_administer? = role?(:administrator)

  # Whether this user may submit and edit catalog data (the Librarian role).
  def can_catalog? = role?(:librarian)

  # Whether this user may author copyright dossiers (the Researcher role).
  def can_research? = role?(:researcher)

  # Whether this user may access protected books. Held by vetted Magicians and
  # by Librarians (who must reach protected titles to catalog them);
  # Administrator is deliberately not implied — grant the role explicitly.
  def can_access_protected? = role?(:magician) || role?(:librarian)

  # Grant +name+ to this user, recording who granted it and why. Raises
  # ActiveRecord::RecordInvalid on an unknown name or a duplicate grant.
  def grant(name, by:, note: nil) = roles.create!(name:, granted_by: by, note:)

  # Grant every role — the founding administrator wears all hats at launch,
  # since there is no one else yet to hold Librarian, Researcher, or Magician.
  # Each grant is still an explicit, auditable {Role} row.
  def grant_founding_roles(by: nil, note: "first run")
    Role::NAMES.each { |name| grant name, by:, note: }
  end
end
