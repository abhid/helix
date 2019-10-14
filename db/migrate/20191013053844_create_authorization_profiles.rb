class CreateAuthorizationProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :authorization_profiles do |t|
      t.string :uuid
      t.string :name
      t.string :description
      t.string :access_type
      t.string :authz_profile_type
      t.string :dacl_name

      t.timestamps
    end
  end
end
