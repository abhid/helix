class EndpointsController < ApplicationController
  def index
    redirect_to root_url
  end

  def show
    @mac_address = params[:id].gsub(/[^a-fA-F0-9]/, "").upcase.gsub(/(.{2})(?=.)/, '\1:\2')
    @endpoint = Endpoint.find_by(mac: @mac_address)

    @session = Session.find_by(mac: @mac_address)
    @mnt_ep = Rails.cache.fetch("mnt_session_#{@session.mac}") { $mnt.session_filterByMAC(@mac_address)["sessionParameters"] }
    @ers_ep = Rails.cache.fetch("ers_ep_#{@session.mac}") { $ers.ep_get($ers.ep_filterByMAC(@mac_address)["SearchResult"]["resources"][0]["id"])["ERSEndPoint"] }

    prime_list = JSON.parse($prime.get("ClientDetails.json?.nocount=true&macAddress=\"#{@mac_address}\"").body)["queryResponse"]["entityId"]
    if prime_list
      @prime_info = JSON.parse($prime.get("ClientDetails/#{prime_list[0]["$"]}.json?.nocount=true").body)["queryResponse"]["entityId"]["clientDetailsDTO"]
    end
    @ep_group = EndpointGroup.find_by(uuid: @ers_ep["groupId"])
  end
end
