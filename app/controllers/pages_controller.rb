class PagesController < ApplicationController
  skip_before_action :authenticate_user, only: [:login, :status]

  def index

  end

  def status
    @session = Session.find_by(ip_address: request.ip)
    if @session.nil?
      render "pages/no_entry.html.erb"
    else
      @mnt_ep = Rails.cache.fetch("mnt_session_#{@session.mac}") { $mnt.session_filterByIP(request.ip)["sessionParameters"] }
      @ers_ep = Rails.cache.fetch("ers_ep_#{@session.mac}") { $ers.ep_get($ers.ep_filterByMAC(@session.mac)["SearchResult"]["resources"][0]["id"])["ERSEndPoint"] }

      prime_list = JSON.parse($prime.get("ClientDetails.json?.nocount=true&macAddress=\"#{@session.mac}\"").body)["queryResponse"]["entityId"]
      if prime_list
        @prime_info = JSON.parse($prime.get("ClientDetails/#{prime_list[0]["$"]}.json?.nocount=true").body)["queryResponse"]["entity"][0]["clientDetailsDTO"]
      end

      @ep_group = EndpointGroup.find_by(uuid: @ers_ep["groupId"])
      # Show a different layout based on current_user status
      render "endpoints/show", layout: session[:user_id] ? "application" : "guest"
    end
  end

  def login
    if session[:user_id]
      redirect_back(fallback_location: root_path) and return
    end
    if request.method == "POST"
      # Validate credentials
      ad_user = SimpleAD::User.authenticate(params[:username], params[:password], {server: Rails.configuration.ad["server"], base: Rails.configuration.ad["base"], domain: Rails.configuration.ad["domain"]})
      if ad_user
        # We have a valid user. Log them in.
        user = User.find_or_create_by(username: ad_user.samaccountname[0])
        user.name = ad_user.displayname[0]
        user.save
        session[:user_id] = user.id
        redirect_back(fallback_location: root_path) and return
      else
        # Invalid user. Kick them back to the login screen.
        flash[:error] = "Invalid username / password."
      end
    end
    render layout: false
  end

  def logout
    session[:user_id] = nil
    redirect_to login_path
  end

  def streaminglog
    ise_session = Pxgrid::ISE::Session.new($pxgrid)
    @sessions = ise_session.getSessions(params[:timestamp]).sort_by { |session| session["timestamp"] }.reverse!
    render partial: 'livelog_row', collection: @sessions, as: :session
  end
end
