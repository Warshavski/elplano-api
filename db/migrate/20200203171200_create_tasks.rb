class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.references :author, null: false, foreign_key: { to_table: :students }, index: true
      t.references :event,  null: false, foreign_key: true, index: true

      t.string  :title, null: false
      t.text    :description

      t.jsonb :extra_links

      t.timestamp :expired_at

      t.timestamps
    end

    add_index :tasks, %i[created_at id], order: { created_at: :asc, id: :asc }
    add_index :tasks, %i[updated_at id], order: { updated_at: :asc, id: :asc }
    add_index :tasks, %i[expired_at id], order: { expired_at: :asc, id: :asc }
  end
end
