#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# frozen_string_literal: true

json.extract! catalog_condition, :id, :name, :created_at, :updated_at
json.url catalog_condition_url(catalog_condition, format: :json)
