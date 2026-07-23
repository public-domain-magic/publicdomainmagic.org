#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# frozen_string_literal: true

json.array! @catalog_form_of_works, partial: "catalog/form_of_works/catalog_form_of_work", as: :catalog_form_of_work
