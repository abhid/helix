class PagesController < ApplicationController
  def index

  end

  def status
    @session = Session.find_by(ip_address: request.ip)
    if @session.nil?
      render html: helpers.tag.strong("Not a valid ISE endpoint")
    else
      @mnt_ep = Rails.cache.fetch("mnt_session_#{@session.mac}") { $mnt.session_filterByIP(request.ip)["sessionParameters"] }
      @ers_ep = Rails.cache.fetch("ers_ep_#{@session.mac}") { $ers.ep_get($ers.ep_filterByMAC(@session.mac)["SearchResult"]["resources"][0]["id"])["ERSEndPoint"] }

      @ep_group = EndpointGroup.find_by(uuid: @ers_ep["groupId"])
      render "endpoints/show"
    end
  end
end
