# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# View helpers for the public library's book pages.
module BooksHelper
  # The names of a book's creators — its work-level "created" contributions —
  # as a display sentence ("Jean Hugard and Frederick Braue"). Blank when no
  # creator is recorded. Reads the preloaded contributions, so it adds no query.
  def book_creators(listing)
    listing.work.contributions
      .select { |contribution| contribution.role == "created" }
      .filter_map { |contribution| contribution.agent.name }
      .to_sentence
  end
end
