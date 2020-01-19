class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities, bulk: true do |t|
      t.references :user, null: false, foreign_key: true, index: true

      t.string :uid, null: false, index: true
      t.integer :provider, null: false

      t.timestamps
    end

    add_index :identities, %i[user_id provider], unique: true
  end
end
