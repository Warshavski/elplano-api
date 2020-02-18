class CreateAuditEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :audit_events do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }, index: true
      t.references :entity, polymorphic: true, null: false, index: true

      t.integer :audit_type, null: false, index: true

      t.jsonb :details

      t.timestamps
    end

    add_index :audit_events, %i[created_at author_id]
    add_index :audit_events, %i[entity_id entity_type id], order: { id: :desc }
  end
end
