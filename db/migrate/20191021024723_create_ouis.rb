class CreateOuis < ActiveRecord::Migration[6.0]
  def change
    create_table :ouis do |t|
      t.macaddr :oui, index: true
      t.string :vendor, index: true

      t.timestamps
    end
  end
end
