# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Real-data seeding for the dev and production databases. Unlike test fixtures
# (which insert with fixed ids and bypass validations), the seed corpus in
# +db/seeds/*.yml+ is loaded through the ordinary model layer by {Seeds::Loader},
# so validations, normalization, and enums all run.
module Seeds
end
