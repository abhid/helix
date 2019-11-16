require 'open-uri'
require 'pycall/import'
include PyCall::Import
pyfrom 'ciscoconfparse', import: "CiscoConfParse"

class NetworkDevicesController < ApplicationController
  def index
    @pagy, @network_devices = pagy(NetworkDevice.order(:name).all)
  end

  def show
    @network_device = NetworkDevice.find(params[:id])
    begin
      running_config = open(Setting["gitlab"]["path"].gsub("%FILE_PATH%", @network_device.name), "PRIVATE-TOKEN" => Setting["gitlab"]["token"], ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
      @config = CiscoConfParse.new(running_config.path, factory: true)
    rescue
    end
  end

  def running_config
    @network_device = NetworkDevice.find(params[:id])
    begin
      @running_config = open(Setting["gitlab"]["path"].gsub("%FILE_PATH%", @network_device.name), "PRIVATE-TOKEN" => Setting["gitlab"]["token"], ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
    rescue
      render plain: "No configs found for #{@network_device.name}.\nPlease validate Gitlab repo path (#{Setting["gitlab"]["path"].gsub("%FILE_PATH%", @network_device.name)})." and return
    end
    render partial: "running_config"
  end

  def config_analyze
    @network_device = NetworkDevice.find(params[:id])
    begin
      running_config = open(Setting["gitlab"]["path"].gsub("%FILE_PATH%", @network_device.name), "PRIVATE-TOKEN" => Setting["gitlab"]["token"], ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
    rescue
      render plain: "No configs found for #{@network_device.name}.\nPlease validate Gitlab repo path (#{Setting["gitlab"]["path"].gsub("%FILE_PATH%", @network_device.name)})." and return
    end
    @conf_parse = CiscoConfParse.new(running_config.path, factory: true)
  end

  def update
    @network_device = NetworkDevice.find(params[:id])
    @network_device.description = params[:description]
    @network_device.save
    # TODO: Sync with ISE and update attributes there.

    render json: @network_device
  end

  def oxidized_conf
    @network_devices = NetworkDevice.all
    render "oxidized_conf", layout: false
  end
end
