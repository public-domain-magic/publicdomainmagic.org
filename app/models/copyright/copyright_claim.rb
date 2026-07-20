# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# A third party asserting rights beyond heirs — e.g. a publisher claiming
# "full permission granted us" through a chain of custody. These are
# researched claims needing citations, not free text buried in an
# author-research +heirs+ column; the report must surface them.
class Copyright::CopyrightClaim < ApplicationRecord
  belongs_to :investigation

  has_many :citations, as: :citable, dependent: :destroy

  validates :claimant_name, presence: true
end
