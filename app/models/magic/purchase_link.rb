# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# A commerce hook on a listing: where to buy the book, including affiliate
# and dealer links for works still counting down to the public domain (the
# Copyright seam supplies the countdown). URLs are presence-only — dealer
# and affiliate URLs take many shapes.
class Magic::PurchaseLink < ApplicationRecord
  belongs_to :listing, inverse_of: :purchase_links

  validates :label, presence: true
  validates :url, presence: true
end
