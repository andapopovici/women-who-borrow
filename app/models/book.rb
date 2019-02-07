class Book < ApplicationRecord
  has_and_belongs_to_many :tags
  belongs_to :user, foreign_key: "user_id"
end
