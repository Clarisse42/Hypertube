class EditUser < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :last_connection, :datetime
  end
end
