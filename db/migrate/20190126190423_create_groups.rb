# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.references :president,
                   null: false,
                   foreign_key: { to_table: :students },
                   index: true

      t.string  :number,  limit: 25, null: false
      t.string  :title,   limit: 200

      t.timestamps
    end
  end
end
