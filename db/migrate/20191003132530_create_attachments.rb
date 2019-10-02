class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.references :user,       null: false, foreign_key: true,  index: true
      t.references :attachable, null: false, polymorphic: true

      t.jsonb :attachment_data, null: false

      t.timestamps
    end

    add_index :attachments, %i[attachable_id attachable_type]
  end
end
