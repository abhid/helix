class SyncIseGroupsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Sync EIG
    $ers.eig_getAll().each do |ers_eig|
      eig = EndpointGroup.find_or_create_by(uuid: ers_eig["id"])
      eig.name = ers_eig["name"]
      eig.description = ers_eig["description"]
      eig.save
    end

    # Sync DACL
    $ers.dacl_getAll().each do |ers_dacl|
      dacl = DownloadableAcl.find_or_create_by(uuid: ers_dacl["id"])
      dacl.name = ers_dacl["name"]
      dacl.description = ers_dacl["description"]
      dacl.save
    end

    # Sync NDG
    $ers.ndg_getAll().each do |ers_ndg|
      ndg = NetworkDeviceGroup.find_or_create_by(uuid: ers_ndg["id"])
      ndg.name = ers_ndg["name"]
      ndg.description = ers_ndg["description"]
      ndg.save
    end

    # Sync ND
    $ers.nd_getAll().each do |ers_nd|
      nd = NetworkDevice.find_or_create_by(uuid: ers_nd["id"])
      nd.name = ers_nd["name"]
      nd.description = ers_nd["description"]
      nd.save
    end

    # Sync AZNProfile
    $ers.aznprofile_getAll().each do |ers_azn|
      azn = AuthorizationProfile.find_or_create_by(uuid: ers_azn["id"])
      azn.name = ers_azn["name"]
      azn.description = ers_azn["description"]
      azn.save
    end
  end
end
