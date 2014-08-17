Rails.application.routes.draw do
  root 'home#index'

  github_authenticate(org: ENV['GITHUB_ORG']) do
    resources :services do
      resources :metrics, shallow: true
    end
  end
end
