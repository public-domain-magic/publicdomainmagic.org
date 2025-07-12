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
