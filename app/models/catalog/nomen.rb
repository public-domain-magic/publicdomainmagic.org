# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# IFLA LRM: an appellation by which an agent is known — birth names, legal
# names, spellings, stage names, pen names. A person and a name are different
# things; never merge agents on name-string equality.
class Catalog::Nomen < ApplicationRecord
  KINDS = %w[birth legal spelling stage pen].freeze

  belongs_to :agent

  enum :kind, KINDS.index_by(&:itself), validate: true

  validates :name, presence: true
end
