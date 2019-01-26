class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.belongs_to :user,   null: false, foreign_key: true

      t.string :full_name,  limit: 200
      t.string :email,      limit: 100
      t.string :phone,      limit: 50

      t.text  :about
      t.jsonb :social_networks, null: false, default: {}

      t.boolean :president, null: false, default: false

      t.timestamps
    end
  end
end
