class SyncNdgJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Sync NDG
    $ers.ndg_getAll().each do |ers_ndg|
      ndg = NetworkDeviceGroup.find_or_create_by(uuid: ers_ndg["id"])
      ndg.name = ers_ndg["name"]
      ndg.description = ers_ndg["description"]
      ndg.save
    end
  end
end
