class ChangeName2 < ActiveRecord::Migration[5.1]
  def change
    remove_column :users_auths, :uid

  end
end
