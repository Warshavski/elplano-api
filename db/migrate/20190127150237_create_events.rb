class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title, null: false, length: 250
      t.string :description

      t.references :creator,
                   null: false, foreign_key: { to_table: :students }, index: true

      t.datetime :start_at, null: false
      t.datetime :end_at
      t.string :timezone, null: false

      t.jsonb :recurrence, null: false, default: []

      t.timestamps
    end
  end
end
