class FileSize20 < ActiveRecord::Migration[5.1]
  def up
    change_column :torrents, :filesize, :bigint
  end
end
