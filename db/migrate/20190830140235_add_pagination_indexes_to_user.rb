class AddPaginationIndexesToUser < ActiveRecord::Migration[5.2]
  def change
    add_index :users, [:created_at, :id], order: { created_at: :asc, id: :asc }
    add_index :users, [:updated_at, :id], order: { updated_at: :asc, id: :asc }

    add_index :users, [:banned_at, :id],    order: { banned_at: :asc, id: :asc }
    add_index :users, [:confirmed_at, :id], order: { confirmed_at: :asc, id: :asc }

    add_index :users, [:email, :id],    order: { email: :asc, id: :asc }
    add_index :users, [:username, :id], order: { username: :asc, id: :asc }
  end
end
