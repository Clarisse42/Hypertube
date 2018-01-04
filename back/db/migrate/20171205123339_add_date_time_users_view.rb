class AddDateTimeUsersView < ActiveRecord::Migration[5.1]
  def change
    add_column :users_views, :datetime, :datetime
  end
end
