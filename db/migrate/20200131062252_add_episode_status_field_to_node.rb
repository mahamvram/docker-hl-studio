class AddEpisodeStatusFieldToNode < ActiveRecord::Migration[6.0]
  def change
  	add_column :nodes, :episode_status, :string
  end
end
