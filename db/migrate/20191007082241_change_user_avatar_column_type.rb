class ChangeUserAvatarColumnType < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :avatar, :text
    rename_column :users, :avatar, :avatar_data
  end

  def down
    rename_column :users, :avatar_data, :avatar
    change_column :users, :avatar, :string
  end
end
