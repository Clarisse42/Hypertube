class ChangeName < ActiveRecord::Migration[5.1]
  def up
    rename_table :users_auths, :users_auths
  end
end
