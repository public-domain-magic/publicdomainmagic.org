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

Web::Engine.routes.draw do
  root "static_pages#index"
  get "/ebooks", to: "static_pages#ebooks", as: "ebooks"
  scope "/about", as: "about" do
    get "/", to: "static_pages#about"
    get "/our-goals", to: "static_pages#about_our_goals", as: "our_goals"
    get "/exposure", to: "static_pages#about_exposure", as: "exposure"
    get "/dual-license", to: "static_pages#about_dual_license", as: "dual_license"
    get "/accessibility", to: "static_pages#accessibility", as: "accessibility"
  end
  get "/newsletter", to: "static_pages#newsletter", as: "newsletter"
  get "/contribute", to: "static_pages#contribute", as: "contribute"
end
