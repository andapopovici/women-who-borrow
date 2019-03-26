class Book < ApplicationRecord
  has_and_belongs_to_many :tags
  has_one :reservation, dependent: :destroy
  belongs_to :user, foreign_key: "user_id"

  validate :cannot_edit_reserved_or_booked
  before_destroy :cannot_destroy_reserved_or_booked

  STATUSES = [
    AVAILABLE = 'available',
    RESERVED = 'reserved',
    BORROWED = 'borrowed'
  ]

  validates :status, :inclusion => { :in => STATUSES }, :allow_blank => false

  scope :borrowed, -> { where(status: BORROWED) }
  scope :reserved, -> { where(status: RESERVED) }

  def belongs_to?(current_user)
    user == current_user
  end

  def is_available?
    status == AVAILABLE
  end

  def available_to_borrow_by?(current_user)
    status == AVAILABLE && !belongs_to?(current_user)
  end

  def reserved_by?(current_user)
    status == RESERVED && reservation.user == current_user
  end

  def borrower
    reservation.user
  end

  def is_reserved?
    reservation && status == RESERVED
  end

  def is_borrowed?
    status == BORROWED
  end

  private

  def cannot_edit_reserved_or_booked
    if status != AVAILABLE && (status_change == nil)
      self.errors[:status] << "This book has been #{status} and cannot be edited"
    end
  end

  def cannot_destroy_reserved_or_booked
    if status != AVAILABLE
      self.errors[:status] << "This book has been #{status} and cannot be deleted"
      throw :abort
    end
  end

end
