class User < ApplicationRecord
  include Clearance::User

  has_many :books, dependent: :destroy
  has_many :reservations, dependent: :destroy

  def friendly_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def can_edit?(object)
    object.is_editable_by?(self)
  end

  def is_editable_by?(user)
    self == user
  end
end
