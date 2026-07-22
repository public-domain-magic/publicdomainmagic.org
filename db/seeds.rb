# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Loads the real book corpus (db/seeds/*.yml) through the model layer. Idempotent
# by construction (see Seeds::Loader), so `bin/rails db:seed` is safe to run at any
# time in any environment — it only inserts rows that do not exist yet.
Seeds::Loader.new.load!
