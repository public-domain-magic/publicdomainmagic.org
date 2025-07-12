Rails.application.routes.draw do
  mount Catalog::Engine => "/catalog"
end
