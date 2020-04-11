class ChangeSocialNetworksDefaultValueForStudents < ActiveRecord::Migration[5.2]
  def change
    change_column_default :students, :social_networks, from: {}, to: []
  end
end
