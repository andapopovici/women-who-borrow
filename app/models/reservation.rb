class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :book

  def approved?
    approved_at?
  end
end
