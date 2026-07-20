# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Per-claim evidence: a source URL (optionally with the supporting quote and
# access date) attached to any research record. The research documents cite
# multiple sources per claim, so evidence is a first-class table rather than
# inline columns.
class Copyright::Citation < ApplicationRecord
  belongs_to :citable, polymorphic: true

  validates :url, presence: true
end
