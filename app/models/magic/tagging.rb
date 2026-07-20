# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Attaches a tag to something. Polymorphic on purpose: tags attach to
# listings today, and the folksonomy the magicians converting books will
# accrue — effects, sleights, venues — lands on component works and tricks
# later without a schema change.
class Magic::Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  validates :tag_id, uniqueness: { scope: %i[taggable_type taggable_id] }
end
