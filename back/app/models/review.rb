class Review < ApplicationRecord

  validates :message, presence: true
end
