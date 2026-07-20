# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

require "test_helper"

class Copyright::RenewalRecordTest < ActiveSupport::TestCase
  test "requires a renewal number" do
    record = copyright_renewal_records(:benson)
    record.renewal_number = ""
    assert_not record.valid?
    assert record.errors.of_kind?(:renewal_number, :blank)
  end

  test "records a renewal judged not to apply" do
    record = copyright_renewal_records(:benson)
    assert_equal false, record.applies
    assert_match(/different work/, record.assessment)
  end
end
