class AddEventStatus < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE event_status AS ENUM ('confirmed', 'tentative', 'cancelled');
    SQL

    add_column :events, :status, :event_status, null: false, default: 'confirmed'
  end

  def down
    execute <<-SQL
      DROP TYPE event_status;
    SQL

    remove_column :events, :status
  end
end
