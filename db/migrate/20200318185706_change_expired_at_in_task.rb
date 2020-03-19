class ChangeExpiredAtInTask < ActiveRecord::Migration[5.2]
  def change
    change_column :tasks, :expired_at, :date
  end
end
