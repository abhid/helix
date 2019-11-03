class PagesController < ApplicationController
  skip_before_action :authenticate_user, only: [:login, :status]

  def index

  end

  def status
    @session = Session.find_by(ip_address: request.remote_ip)
    unless @session
      session = $mnt.session_filterByIP(request.remote_ip)["sessionParameters"]
      if session
        @session = Session.find_or_create_by(mac: session["calling_station_id"])
        @session.active = true
        @session.mac = session["calling_station_id"]
        @session.username = session["user_name"]
        @session.ip_address = session["framed_ip_address"]
        @session.audit_session_id = session["audit_session_id"]
        @session.save
      end
    else

    end

    if @session.nil?
      render "no_entry.html.erb", layout: "guest"
    else
      @mnt_ep = Rails.cache.fetch("mnt_session_#{@session.mac}") { $mnt.session_filterByIP(request.remote_ip)["sessionParameters"] }
      @ers_ep = Rails.cache.fetch("ers_ep_#{@session.mac}") { $ers.ep_get($ers.ep_filterByMAC(@session.mac)["SearchResult"]["resources"][0]["id"])["ERSEndPoint"] }

      prime_list = JSON.parse($prime.get("ClientDetails.json?.nocount=true&macAddress=\"#{@session.mac}\"").body)["queryResponse"]["entityId"]
      if prime_list
        @prime_info = JSON.parse($prime.get("ClientDetails/#{prime_list[0]["$"]}.json?.nocount=true").body)["queryResponse"]["entity"][0]["clientDetailsDTO"]
      end

      @ep_group = EndpointGroup.find_by(uuid: @ers_ep["groupId"])
      # Show a different layout based on current_user status
      render "endpoints/show", layout: current_user ? "application" : "guest"
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
        user.last_login_ip = request.remote_ip
        user.save
        session[:user_id] = user.id
        redirect_to root_path and return
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

  def settings

  end
end
