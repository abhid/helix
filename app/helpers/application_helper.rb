module ApplicationHelper
  include Pagy::Frontend
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def settings(namespace)
    @settings[namespace] ||= Setting.find_by(namespace: namespace).hash
  end
end
