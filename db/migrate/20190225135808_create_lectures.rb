class CreateLectures < ActiveRecord::Migration[5.2]
  def change
    create_table :lectures do |t|
      t.references :lecturer, foreign_key: true, index: true
      t.references :course, foreign_key: true, index: true

      t.timestamps
    end

    add_index :lectures, %i[lecturer_id course_id], unique: true
  end
end
