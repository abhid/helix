class SyncEigJob < ApplicationJob
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
    
    # Sync EIG
    $ers.eig_getAll().each do |ers_eig|
      eig = EndpointGroup.find_or_create_by(uuid: ers_eig["id"])
      eig.name = ers_eig["name"]
      eig.description = ers_eig["description"]
      eig.save

      # endpoints = $ers.eig_getEndpoints(eig.uuid.to_s)
      # endpoints.each do |endpoint|
      #   ep = Endpoint.find_or_create_by(uuid: endpoint["id"])
      #   ep.name = endpoint["name"]
      #   ep.endpoint_group = eig
      #   ep.save
      # end
    end
  end
end
