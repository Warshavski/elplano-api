class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.references :sender,
                   null: false,
                   foreign_key: { to_table: :students },
                   index: true

      t.references :recipient,
                   null: true,
                   foreign_key: { to_table: :students },
                   index: true

      t.references :group,
                   null: false,
                   foreign_key: true,
                   index: true

      t.string :email, null: false

      t.string :invitation_token, index: { unique: true }

      t.datetime :sent_at, null: false
      t.datetime :accepted_at

      t.timestamps
    end

    add_index :invites, %i[group_id email], unique: true
  end
end
