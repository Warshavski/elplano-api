class CreateAbuseReports < ActiveRecord::Migration[5.2]
  def change
    create_table :abuse_reports do |t|
      t.references :reporter, null: false, foreign_key: { to_table: :users }, index: true
      t.references :user,     null: false, foreign_key: true, index: { unique: true }

      t.text :message, null: false

      t.timestamps
    end
  end
end
