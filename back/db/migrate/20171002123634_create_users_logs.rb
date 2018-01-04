class CreateUsersLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :users_logs do |t|
      t.integer :uid
      t.string :token
      t.integer :date
    end
  end
end
