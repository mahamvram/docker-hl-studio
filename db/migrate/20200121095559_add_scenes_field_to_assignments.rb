class AddScenesFieldToAssignments < ActiveRecord::Migration[6.0]
  def change
  	add_column :assignments, :scenes, :string
  end
end
