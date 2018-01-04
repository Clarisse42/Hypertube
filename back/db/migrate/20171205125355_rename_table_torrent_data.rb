class RenameTableTorrentData < ActiveRecord::Migration[5.1]
  def up
    rename_table :torrent, :torrents
  end
end
