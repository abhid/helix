class SyncNdgJob < ApplicationJob
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
    
    # Sync NDG
    $ers.ndg_getAll().each do |ers_ndg|
      ndg = NetworkDeviceGroup.find_or_create_by(uuid: ers_ndg["id"])
      ndg.name = ers_ndg["name"]
      ndg.description = ers_ndg["description"]
      ndg.save
    end
  end
end
