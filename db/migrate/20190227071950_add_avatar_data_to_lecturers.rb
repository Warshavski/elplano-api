class AddAvatarDataToLecturers < ActiveRecord::Migration[5.2]
  def change
    add_column :lecturers, :avatar_data, :text
  end
end
