class NetworkDeviceGroupsController < ApplicationController
  def index
    @pagy, @network_device_groups = pagy(NetworkDeviceGroup.order(:name).all)
  end

  def show
    @network_device_group = NetworkDeviceGroup.find(params[:id])
  end

  def oxidized_conf
    @network_devices = NetworkDeviceGroup.find(params[:id]).network_devices
    render "network_devices/oxidized_conf", layout: false
  end
end
