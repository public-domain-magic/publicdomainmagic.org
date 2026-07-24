# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Exposure is a per-concept, not a book-wide, fact, and "public" conflated
# copyright-public-domain with openly-teachable. Drop the fabricated +public+
# default so a listing may be left unclassified (NULL) until deliberately
# classified; no book carries an invented access class.
class MakeMagicListingExposureOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :magic_listings, :exposure, true
    change_column_default :magic_listings, :exposure, from: "public", to: nil
  end
end
