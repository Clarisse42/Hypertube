class MovieRevview2 < ActiveRecord::Migration[5.1]
  def change
    add_column :users_logs, :status, :boolean, default: true
  end
end
