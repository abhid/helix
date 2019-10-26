class SyncDaclJob < ApplicationJob
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
    
    # Sync DACL
    $ers.dacl_getAll().each do |ers_dacl|
      dacl = DownloadableAcl.find_or_create_by(uuid: ers_dacl["id"])
      dacl.name = ers_dacl["name"]
      dacl.description = ers_dacl["description"]

      dacl_detail = $ers.dacl_get(ers_dacl["id"])["DownloadableAcl"]
      dacl.dacl = dacl_detail["dacl"]
      dacl.save
    end
  end
end
