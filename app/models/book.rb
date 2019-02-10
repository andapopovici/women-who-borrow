class Book < ApplicationRecord
  has_and_belongs_to_many :tags
  has_one :reservation, dependent: :destroy
  belongs_to :user, foreign_key: "user_id"

  validate :cannot_edit_reserved_or_booked
  before_destroy :cannot_destroy_reserved_or_booked

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

  def reserved_by?(current_user)
    status == RESERVED && reservation.user == current_user
  end

  def has_pending_reservation?
    reservation && status == RESERVED
  end

  def is_borrowed?
    status == BORROWED
  end

  private

  def cannot_edit_reserved_or_booked
    if status != FREE && (status_change == nil)
      self.errors[:status] << "This book has been #{status} and cannot be edited"
    end
  end

  def cannot_destroy_reserved_or_booked
    if status != FREE
      self.errors[:status] << "This book has been #{status} and cannot be deleted"
      throw :abort
    end
  end

end
