# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Abstract base for all models. Shared scopes, validations, and
# query methods belong here.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
