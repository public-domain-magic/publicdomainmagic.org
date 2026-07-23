#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# frozen_string_literal: true

json.extract! catalog_intended_audience, :id, :name, :created_at, :updated_at
json.url catalog_intended_audience_url(catalog_intended_audience, format: :json)
