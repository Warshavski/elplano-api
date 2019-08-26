class AddEventableAssociationToEvent < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :eventable, polymorphic: true, null: false, index: true

    add_index :events, %i[eventable_id eventable_type]
  end
end
