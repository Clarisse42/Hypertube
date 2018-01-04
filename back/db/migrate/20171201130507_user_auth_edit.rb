class UserAuthEdit < ActiveRecord::Migration[5.1]
  def change
    add_column :users_auth, :torrent_data, :text
  end
end
