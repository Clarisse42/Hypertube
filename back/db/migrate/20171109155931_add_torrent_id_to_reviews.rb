class AddTorrentIdToReviews < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :torrent_id, :integer
  end
end
