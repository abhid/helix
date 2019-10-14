module ApplicationHelper
  include Pagy::Frontend
  def current_user
    @current_user ||= "ers_admin"
  end
end
