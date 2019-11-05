class NetworkDeviceGroupDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :network_device_groups_devices, index: false do |t|
      t.belongs_to :network_device, index: true
      t.belongs_to :network_device_group, index: true
    end
  end
end
