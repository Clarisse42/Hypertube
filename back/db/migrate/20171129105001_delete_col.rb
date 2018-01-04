class DeleteCol < ActiveRecord::Migration[5.1]
  def change
    remove_column :users_views, :datetime
    remove_column :reviews, :torrent_id
    drop_table :searches
    drop_table :movies
  end
end
