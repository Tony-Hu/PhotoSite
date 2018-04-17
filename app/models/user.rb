class User < ApplicationRecord
  self.primary_key = "id"
  has_many :photos
  has_many :comments
end
