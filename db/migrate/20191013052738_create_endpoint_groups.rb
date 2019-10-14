class CreateEndpointGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :endpoint_groups do |t|
      t.string :uuid
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
