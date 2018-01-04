class UserView22 < ActiveRecord::Migration[5.1]
  def change
    change_column :users_views, :torrent_id, :string
  end
end
