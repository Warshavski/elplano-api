class AddExtraInfoToStudent < ActiveRecord::Migration[5.2]
  change_table :students, bulk: true do |t|
    t.date :birthday
    t.integer :gender
  end
end
