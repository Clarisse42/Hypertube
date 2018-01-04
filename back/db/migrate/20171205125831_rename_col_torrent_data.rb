class RenameColTorrentData < ActiveRecord::Migration[5.1]
  def change
    rename_column :torrents, :hash, :torrent_id
  end
end
