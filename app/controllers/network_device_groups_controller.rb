class NetworkDeviceGroupsController < ApplicationController
  def index
    @pagy, @network_device_groups = pagy(NetworkDeviceGroup.order(:name).all)
  end
end
