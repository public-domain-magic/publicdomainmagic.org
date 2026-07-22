# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Design, LLC <me@kerricklong.com>
#
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

# Application-wide view helper methods shared across all templates.
module ApplicationHelper
  # The publication year on or before which a work is presumptively in the US
  # public domain — the 96-year window (this year minus 96). Used in the
  # explanatory copy on the static pages.
  def public_domain_year
    Time.current.year - 96
  end

  # The site's inline logotype: the +#pdm-icon+ glyph followed by the stylized
  # "Public Domain Magic" wordmark, for use inline anywhere the copy names the
  # site. Pass +domain+ true for the ".org" domain-name form (with zero-width
  # spaces so it wraps gracefully).
  def pdm_logotype(domain = false)
    if domain
      content_tag(:b, class: "logotype") do
        concat content_tag(:svg, content_tag(:use, nil, href: "#pdm-icon"), class: "icon", width: "1.422em", height: "1em")
        concat content_tag(:span, "Public", class: "public")
        concat "&#8203;".html_safe
        concat content_tag(:span, "Domain", class: "domain")
        concat "&#8203;".html_safe
        concat content_tag(:span, "Magic", class: "magic")
        concat "&#8203;".html_safe
        concat content_tag(:span, ".org", class: "tld")
      end
    else
      content_tag(:b, class: "logotype") do
        concat content_tag(:svg, content_tag(:use, nil, href: "#pdm-icon"), class: "icon", width: "1.422em", height: "1em")
        concat content_tag(:span, "Public", class: "public")
        concat content_tag(:span, " ", class: "space")
        concat content_tag(:span, "Domain", class: "domain")
        concat content_tag(:span, " ", class: "space")
        concat content_tag(:span, "Magic", class: "magic")
      end
    end
  end
end
