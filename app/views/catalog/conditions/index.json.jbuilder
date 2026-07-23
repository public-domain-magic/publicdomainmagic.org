#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# frozen_string_literal: true

json.array! @catalog_conditions, partial: "catalog/conditions/catalog_condition", as: :catalog_condition
