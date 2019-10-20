class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.macaddr :mac, index: true
      t.string :mac_text, index: true
      t.string :ip_address, index: true
      t.string :username, index: true
      t.string :audit_session_id, index: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
