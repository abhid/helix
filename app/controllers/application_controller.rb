class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ApplicationHelper

  before_action :authenticate_user

  private
  def authenticate_user
    redirect_to login_path unless current_user
  end
end
