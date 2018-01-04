class AddMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :movies do |t|
    end

    add_column :movies, :movie_id, :integer, unique: true
    add_column :movies, :torrent_id, :integer
    add_column :movies, :title, :string
    add_column :movies, :poster_path, :string
    add_column :movies, :isdownload, :boolean, default: 0
  end
end
