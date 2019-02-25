class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :title, null: false, limit: 200

      t.references :group,null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :courses, %i[group_id title], unique: true
  end
end
