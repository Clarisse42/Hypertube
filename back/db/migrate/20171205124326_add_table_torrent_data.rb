class AddTableTorrentData < ActiveRecord::Migration[5.1]
  def change
    create_table :torrent do |t|
      t.string :hash
      t.datetime :datetime
      t.integer :filesize
      t.string :path
      t.boolean :completed
    end
  end
end
