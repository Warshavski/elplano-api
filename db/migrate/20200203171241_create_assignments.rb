class CreateAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :assignments do |t|
      t.references :student,    null: false, foreign_key: true, index: true
      t.references :task,       null: false, foreign_key: true, index: true

      t.boolean :accomplished, null: false, default: false

      t.text  :report
      t.jsonb :extra_links

      t.timestamps
    end

    add_index :assignments, %i[student_id task_id], unique: true
  end
end
