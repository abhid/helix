class NetworkDevice < ApplicationRecord
  has_and_belongs_to_many :network_device_groups
end
