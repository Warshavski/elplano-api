class CreateAnnouncements < ActiveRecord::Migration[5.2]
  def change
    create_table :announcements do |t|
      t.text :message, null: false

      t.timestamp :start_at,  null: false
      t.timestamp :end_at,    null: false

      t.string :foreground_color, limit: 7
      t.string :background_color, limit: 7

      t.timestamps
    end

    add_index :announcements, %i[start_at end_at]
  end
end
