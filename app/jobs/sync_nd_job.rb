class SyncNdJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Sync ND
    $ers.nd_getAll().each do |ers_nd|
      nd = NetworkDevice.find_or_create_by(uuid: ers_nd["id"])
      nd.name = ers_nd["name"]
      nd.description = ers_nd["description"]

      nd_detail = $ers.nd_get(ers_nd["id"])["NetworkDevice"]
      if (nd_detail["NetworkDeviceIPList"].length > 0)
        nd.ip_address = nd_detail["NetworkDeviceIPList"][0]["ipaddress"]
      end
      nd.save
    end
  end
end
