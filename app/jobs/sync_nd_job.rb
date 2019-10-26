class SyncNdJob < ApplicationJob
  queue_as :default

  def perform(*args)
    r = Redis.new
    if r.exists "#{self.class}_execute"
      puts "Exceeded retry rate of 30s. key: #{self.class}_execute"
      return
    else
      r.set "#{self.class}_execute", true
      r.expire "#{self.class}_execute", 30
    end
    
    # Sync ND
    $ers.nd_getAll().each do |ers_nd|
      nd = NetworkDevice.find_or_create_by(uuid: ers_nd["id"])
      nd.name = ers_nd["name"]
      nd.description = ers_nd["description"]

      nd_detail = $ers.nd_get(ers_nd["id"])["NetworkDevice"]
      if (nd_detail["NetworkDeviceIPList"].length > 0)
        nd.ip_address = nd_detail["NetworkDeviceIPList"][0]["ipaddress"]
      end
      if (nd_detail["NetworkDeviceGroupList"].length > 0)
        nd_detail["NetworkDeviceGroupList"].each do |group_name|
          nd.network_device_groups << NetworkDeviceGroup.find_by(name: group_name)
        end
      end
      nd.save
    end
  end
end
