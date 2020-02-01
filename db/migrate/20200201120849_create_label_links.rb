class CreateLabelLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :label_links, id: false do |t|
      t.references :target, polymorphic: true, null: false, index: true
      t.references :label, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
