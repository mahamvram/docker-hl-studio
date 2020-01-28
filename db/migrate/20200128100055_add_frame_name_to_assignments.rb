class AddFrameNameToAssignments < ActiveRecord::Migration[6.0]
  def change
  	add_column :assignments, :frame_name, :string
  end
end
