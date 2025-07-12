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
