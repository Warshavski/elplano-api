class AddCourseReferenceToEvent < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :course, foreign_key: true, index: true
  end
end
