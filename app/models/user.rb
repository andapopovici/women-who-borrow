class User < ApplicationRecord
  include Clearance::User

  has_many :books, dependent: :destroy
  has_many :reservations

  def friendly_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
