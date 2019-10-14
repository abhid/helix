class NetworkDevicesController < ApplicationController
  def index
    @pagy, @network_devices = pagy(NetworkDevice.order(:name).all)
  end
end
