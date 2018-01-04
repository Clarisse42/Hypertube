class Users_favs< ApplicationRecord
  validates_uniqueness_of :uid, scope: :movie_id
end