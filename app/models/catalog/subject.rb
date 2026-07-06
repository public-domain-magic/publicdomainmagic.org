# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# FRBR "has as subject": links a work to whatever it is about. The subject is
# polymorphic — a Group 3 concept, or (Group 3 permits it) another Group 1
# entity such as a work.
class Catalog::Subject < ApplicationRecord
  belongs_to :work
  belongs_to :subject, polymorphic: true

  validates :subject_id, uniqueness: { scope: %i[work_id subject_type] }
end
