class CreateBugReports < ActiveRecord::Migration[5.2]
  def change
    create_table :bug_reports do |t|
      t.references :reporter, null: false, foreign_key: { to_table: :users }, index: true

      t.text :message, null: false

      t.timestamps
    end

    add_index :bug_reports, [:created_at, :id], order: { created_at: :asc, id: :asc }
    add_index :bug_reports, [:updated_at, :id], order: { updated_at: :asc, id: :asc }
  end
end
