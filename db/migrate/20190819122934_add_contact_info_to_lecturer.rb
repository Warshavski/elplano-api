class AddContactInfoToLecturer < ActiveRecord::Migration[5.2]
  def change
    add_column :lecturers, :email, :string
    add_column :lecturers, :phone, :string
  end
end
