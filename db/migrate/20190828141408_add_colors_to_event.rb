class AddColorsToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column  :events,:foreground_color, :string, limit: 7
    add_column  :events,:background_color, :string, limit: 7
  end
end
