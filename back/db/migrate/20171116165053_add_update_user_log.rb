class AddUpdateUserLog < ActiveRecord::Migration[5.1]
  def up
    change_column :users_logs, :date, :datetime
  end
end
