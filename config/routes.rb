Rails.application.routes.draw do
  resources :buildings do
    collection do
      post "location", to: "buildings#location"
      post "information", to: "buildings#information"
      post 'route', to: "buildings#route"
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
