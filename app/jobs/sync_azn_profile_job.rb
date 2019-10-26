class SyncAznProfileJob < ApplicationJob
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
    
    # Sync AZNProfile
    $ers.aznprofile_getAll().each do |ers_azn|
      azn = AuthorizationProfile.find_or_create_by(uuid: ers_azn["id"])
      azn.name = ers_azn["name"]
      azn.description = ers_azn["description"]

      azn_detail = $ers.aznprofile_get(ers_azn["id"])["AuthorizationProfile"]
      azn.access_type = azn_detail["accessType"]
      azn.authz_profile_type = azn_detail["authzProfileType"]
      azn.dacl_name = azn_detail["airespaceACL"] || azn_detail["daclName"]
      azn.save
    end
  end
end
