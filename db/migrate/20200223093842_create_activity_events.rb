class CreateActivityEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_events do |t|
      t.references :author, null: false, index: true, foreign_key: { to_table: :users }
      t.references :target, null: false, index: true, polymorphic: true

      t.integer :action, null: false, index: true, limit: 2
      t.jsonb   :details

      t.timestamps
    end

    add_index :activity_events, %i[created_at author_id]
    add_index :activity_events, %i[target_id target_type id], order: { id: :desc }
  end
end
