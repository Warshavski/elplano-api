class CreateUserStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :user_statuses do |t|
      t.references :user,  null: false, foreign_key: true, index: { unique: true}

      t.string :emoji, null: false, default: 'speech_balloon'
      t.string :message, limit: 100

      t.timestamps
    end
  end
end
