class User < ApplicationRecord
  include Clearance::User

  has_many :books, dependent: :destroy


end
