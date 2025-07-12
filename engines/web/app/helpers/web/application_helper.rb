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

module Web
  module ApplicationHelper
    def public_domain_year
      Time.zone.now.year - 96
    end

    def pdm_logotype(domain = false)
      if domain
        content_tag(:b, class: "logotype") do
          concat content_tag(:svg, content_tag(:use, nil, href: "#pdm-icon"), class: "icon", width: "1.422em", height: "1em")
          concat content_tag(:span, "Public", class: "public")
          concat "&#8203;".html_safe
          concat content_tag(:span, "Domain", class: "domain")
          concat "&#8203;".html_safe
          concat content_tag(:span, "Magic",  class: "magic")
          concat "&#8203;".html_safe
          concat content_tag(:span, ".org",   class: "tld")
        end
      else
        content_tag(:b, class: "logotype") do
          concat content_tag(:svg, content_tag(:use, nil, href: "#pdm-icon"), class: "icon", width: "1.422em", height: "1em")
          concat content_tag(:span, "Public", class: "public")
          concat content_tag(:span, " ",      class: "space")
          concat content_tag(:span, "Domain", class: "domain")
          concat content_tag(:span, " ",      class: "space")
          concat content_tag(:span, "Magic",  class: "magic")
        end
      end
    end
  end
end
