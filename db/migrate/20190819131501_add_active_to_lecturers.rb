class AddActiveToLecturers < ActiveRecord::Migration[5.2]
  def change
    add_column :lecturers, :active, :boolean, null: false, default: true

    add_index :lecturers, :active, where: 'active = true'
  end
end
