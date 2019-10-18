class NetworkDeviceGroup < ApplicationRecord
  has_and_belongs_to_many :network_devices
end
