class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.references :group, null: false, foreign_key: true, index: true

      t.string :title, null: false, limit: 255, index: true
      t.string :color, null: false, limit: 7

      t.string :description

      t.timestamps
    end

    add_index :labels, %i[group_id title], unique: true
  end
end
