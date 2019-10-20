class CreateEndpoints < ActiveRecord::Migration[6.0]
  def change
    create_table :endpoints do |t|
      t.string :name
      t.uuid :uuid
      t.text :description
      t.macaddr :mac
      t.references :endpoint_group

      t.references :added_by, index: true, foreign_key: {to_table: :users}
      t.references :modified_by, index: true, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
