#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# frozen_string_literal: true

json.extract! catalog_item, :id, :identifier, :provenance, :marks, :manifestation_id, :condition_id, :created_at, :updated_at
json.url catalog_item_url(catalog_item, format: :json)
