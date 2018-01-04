class Users_log < ApplicationRecord

  # has_secure_token :token
  validates :token, presence: true, uniqueness: true
  validates :uid, presence: true
  validates :date, presence: true
end
