class PagesController < ApplicationController
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
      render "endpoints/show"
    end
  end

  def livelog
    ise_session = Pxgrid::ISE::Session.new($pxgrid)
    @sessions = ise_session.getSessions((Time.now - 1.minutes).iso8601).sort_by { |session| session["timestamp"] }.reverse!
  end

  def streaminglog
    ise_session = Pxgrid::ISE::Session.new($pxgrid)
    @sessions = ise_session.getSessions(params[:timestamp]).sort_by { |session| session["timestamp"] }.reverse!
    render partial: 'livelog_row', collection: @sessions, as: :session
  end
end
