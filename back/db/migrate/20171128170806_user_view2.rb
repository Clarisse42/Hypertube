class UserView2 < ActiveRecord::Migration[5.1]
  def change
    add_column :users_views, :movie_id, :string
    change_column :users_views, :torrent_id, :string
  end
end
