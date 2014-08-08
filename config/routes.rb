Rails.application.routes.draw do
  resources :services
  root to: redirect(path: '/services', status: 302)
end
