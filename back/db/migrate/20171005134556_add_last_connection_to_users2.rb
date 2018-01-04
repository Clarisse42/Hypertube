class AddLastConnectionToUsers2 < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_connection, :string
  end
end
