class RenameCol < ActiveRecord::Migration[5.1]
  def up
    change_column :torrents, :path, :text
  end
end
