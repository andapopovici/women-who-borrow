class Book < ApplicationRecord
  has_and_belongs_to_many :tags
  has_one :reservation
  belongs_to :user, foreign_key: "user_id"

  validate :cannot_edit_reserved

  STATUSES = [
    FREE = 'free',
    RESERVED = 'reserved',
    BORROWED = 'borrowed'
  ]

  validates :status, :inclusion => { :in => STATUSES }, :allow_blank => false

  def belongs_to?(current_user)
  	user == current_user
  end

  def available_to_borrow?(current_user)
  	status == FREE && !belongs_to?(current_user)
  end

  def reserve(current_user) 
    if update_attributes(status: RESERVED)
      reservation = Reservation.new(user: current_user, book: self)
      reservation.save
    end
  end

  private 

  def cannot_edit_reserved 
    if (status == RESERVED) && (status_change == nil) 
      self.errors[:status] << "This book has been reserved and cannot be edited"
    end
  end
end
