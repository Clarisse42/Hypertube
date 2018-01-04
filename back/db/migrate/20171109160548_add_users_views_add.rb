class AddUsersViewsAdd < ActiveRecord::Migration[5.1]
  def change
    add_column :users_views, :uid, :integer
    add_column :users_views, :torrent_id, :integer
    add_column :users_views, :datetime, :datetime
    add_column :movies, :datetime, :datetime
  end
end
