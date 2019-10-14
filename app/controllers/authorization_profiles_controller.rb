class AuthorizationProfilesController < ApplicationController
  def index
    @pagy, @authorization_profiles = pagy(AuthorizationProfile.order(:name).all)
  end
end
