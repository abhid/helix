class CreateNetworkDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :network_devices do |t|
      t.string :uuid
      t.string :name
      t.string :description
      t.string :type
      t.string :ip_address
      t.boolean :updated, default: false

      t.timestamps
    end
  end
end
