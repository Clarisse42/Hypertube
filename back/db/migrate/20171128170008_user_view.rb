class UserView < ActiveRecord::Migration[5.1]
  def change
    add_column :users_views, :time_elapsed, :integer, default: 0
  end
end
