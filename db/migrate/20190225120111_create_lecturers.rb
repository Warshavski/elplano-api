class CreateLecturers < ActiveRecord::Migration[5.2]
  def change
    create_table :lecturers do |t|
      t.string :first_name,   null: false, limit: 40
      t.string :last_name,    null: false, limit: 40
      t.string :patronymic,   null: false, limit: 40

      t.references :group,null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :lecturers,
              %i[group_id first_name last_name patronymic],
              unique: :true,
              name: 'index_lecturers_on_full_name_and_group'
  end
end
