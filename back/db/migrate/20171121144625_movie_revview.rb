class MovieRevview < ActiveRecord::Migration[5.1]
  def change
    change_column :reviews, :movie_id, :string
  end
end
