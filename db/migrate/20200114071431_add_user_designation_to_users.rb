class AddUserDesignationToUsers < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :user_designation, :string
  end
end
