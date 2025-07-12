=begin
`public_domain_magic`, the PublicDomainMagic.org information system
Copyright (C) 2025  Kerrick Long <me@kerricklong.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
=end

require "test_helper"

module Web
  class ApplicationHelperTest < ActionView::TestCase
    test "public_domain_year provides the year U.S. written works are in the public domain regardless of renewal, notice, or facts that need advanced research" do
      travel_to Time.zone.local(2024, 6, 15) do
        assert_equal 1928, public_domain_year
      end
      travel_to Time.zone.local(2025, 1, 1) do
        assert_equal 1929, public_domain_year
      end
    end

    test "pdm_logotype provides markup to render an inline logo with webfonts" do
      assert_dom_equal %(<b class="logotype"><svg class="icon" width="1.422em" height="1em"><use href="#pdm-icon" /></svg><span class="public">Public</span><span class="space"> </span><span class="domain">Domain</span><span class="space"> </span><span class="magic">Magic</span></b>), pdm_logotype
    end

    test "pdm_logotype can also render the stylized domain name" do
      assert_dom_equal %(<b class="logotype"><svg class="icon" width="1.422em" height="1em"><use href="#pdm-icon" /></svg><span class="public">Public</span>&#8203;<span class="domain">Domain</span>&#8203;<span class="magic">Magic</span>&#8203;<span class="tld">.org</span></b>), pdm_logotype(:domain)
    end
  end
end
