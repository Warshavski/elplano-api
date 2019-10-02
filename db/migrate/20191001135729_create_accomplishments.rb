class CreateAccomplishments < ActiveRecord::Migration[5.2]
  def change
    create_table :accomplishments do |t|
      t.references :student,    null: false, foreign_key: true, index: true
      t.references :assignment, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :accomplishments, %i[student_id assignment_id], unique: true
  end
end
