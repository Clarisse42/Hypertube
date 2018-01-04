class UserAuth < ActiveRecord::Migration[5.1]
  def change
    create_table :users_auth do |t|
      t.string :token
      t.integer :uid
      t.boolean :active, default: true
    end
  end
end
