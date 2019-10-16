class NetworkDevicesController < ApplicationController
  def index
    @pagy, @network_devices = pagy(NetworkDevice.order(:name).all)
  end

  def show
    @network_device = NetworkDevice.find(params[:id])
  end

  def edit

  end

  def update
    @network_device = NetworkDevice.find(params[:id])
    @network_device.description = params[:description]
    @network_device.save
    # TODO: Sync with ISE and update attributes there.

    render json: @network_device
  end
end
