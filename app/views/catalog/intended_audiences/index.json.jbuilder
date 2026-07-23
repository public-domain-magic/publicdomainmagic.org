#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# frozen_string_literal: true

json.array! @catalog_intended_audiences, partial: "catalog/intended_audiences/catalog_intended_audience", as: :catalog_intended_audience
