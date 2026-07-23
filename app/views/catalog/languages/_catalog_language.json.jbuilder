#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# frozen_string_literal: true

json.extract! catalog_language, :id, :name, :code, :created_at, :updated_at
json.url catalog_language_url(catalog_language, format: :json)
