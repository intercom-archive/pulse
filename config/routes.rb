Rails.application.routes.draw do
  github_authenticate(org: ENV['GITHUB_ORG']) do
    root to: redirect(path: '/services', status: 302)

    resources :services
    resources :metrics
  end
end
