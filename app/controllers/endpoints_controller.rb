class EndpointsController < ApplicationController
  skip_before_action :authenticate_user, only: [:show, :show_infoblox, :show_ise_mnt, :show_ise_ers, :show_prime]
  def index
    redirect_to root_url
  end

  def show
    @mac_address = params[:id].gsub(/[^a-fA-F0-9]/, "").upcase.gsub(/(.{2})(?=.)/, '\1:\2')
  end

  # Async Controllers
  def show_infoblox
    @mac_address = params[:mac].gsub(/[^a-fA-F0-9]/, "").upcase.gsub(/(.{2})(?=.)/, '\1:\2')
    leases = Infoblox::Lease.find($ib_ctx, {"hardware~": @mac_address.downcase})
    @ib_lease = leases.first unless leases.empty?
    render partial: "show_infoblox"
  end

  def show_ise_mnt
    @mac_address = params[:mac].gsub(/[^a-fA-F0-9]/, "").upcase.gsub(/(.{2})(?=.)/, '\1:\2')
    @mnt_ep = $mnt.session_filterByMAC(@mac_address)["sessionParameters"]
    # @ers_ep = $ers.ep_get($ers.ep_filterByMAC(@mac_address)["SearchResult"]["resources"][0]["id"])["ERSEndPoint"]
    render partial: "show_ise_mnt"
  end

  def show_ise_ers
    @mac_address = params[:mac].gsub(/[^a-fA-F0-9]/, "").upcase.gsub(/(.{2})(?=.)/, '\1:\2')
    # @mnt_ep = $mnt.session_filterByMAC(@mac_address)["sessionParameters"]
    @ers_ep = $ers.ep_get($ers.ep_filterByMAC(@mac_address)["SearchResult"]["resources"][0]["id"])["ERSEndPoint"]
    @ep_group = EndpointGroup.find_by(uuid: @ers_ep["groupId"])
    render partial: "show_ise_ers"
  end

  def show_prime
    @mac_address = params[:mac].gsub(/[^a-fA-F0-9]/, "").upcase.gsub(/(.{2})(?=.)/, '\1:\2')
    prime_list = JSON.parse($prime.get("ClientDetails.json?.nocount=true&macAddress=\"#{@mac_address}\"").body)["queryResponse"]["entityId"]
    if prime_list
      @prime_info = JSON.parse($prime.get("ClientDetails/#{prime_list[0]["$"]}.json?.nocount=true").body)["queryResponse"]["entity"][0]["clientDetailsDTO"]
    end
    render partial: "show_prime"
  end
end
