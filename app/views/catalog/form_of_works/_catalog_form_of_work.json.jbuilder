#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# frozen_string_literal: true

json.extract! catalog_form_of_work, :id, :name, :created_at, :updated_at
json.url catalog_form_of_work_url(catalog_form_of_work, format: :json)
