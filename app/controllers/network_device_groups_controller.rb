class NetworkDeviceGroupsController < ApplicationController
  def index
    @pagy, @network_device_groups = pagy(NetworkDeviceGroup.order(:name).all)
  end

  def show
    @network_device_group = NetworkDeviceGroup.find(params[:id])
  end
end
