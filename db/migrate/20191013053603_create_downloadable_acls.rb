class CreateDownloadableAcls < ActiveRecord::Migration[6.0]
  def change
    create_table :downloadable_acls do |t|
      t.string :uuid
      t.string :name
      t.string :description
      t.text :dacl

      t.timestamps
    end
  end
end
