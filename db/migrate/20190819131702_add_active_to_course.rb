class AddActiveToCourse < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :active, :boolean, null: false, default: true

    add_index :courses, :active, where: 'active = true'
  end
end
