class AddStudentsGroupsReference < ActiveRecord::Migration[5.2]
  def change
    add_reference :students, :group,
                  null: true, foreign_key: true, index: true
  end
end
