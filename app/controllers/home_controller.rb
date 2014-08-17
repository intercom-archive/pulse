class HomeController < ApplicationController
  def index
    return redirect_to services_path if github_authenticated?
    @org_name = ENV['GITHUB_ORG'].try(:capitalize)
  end
end
