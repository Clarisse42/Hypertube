class UpdateTableUsersAuths < ActiveRecord::Migration[5.1]
  def change
    add_column :users_auths, :download, :boolean
    add_column :users_auths, :stream, :boolean
    remove_column :users_auths, :active
  end
end
