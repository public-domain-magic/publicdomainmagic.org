#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# frozen_string_literal: true

json.array! @catalog_languages, partial: "catalog/languages/catalog_language", as: :catalog_language
