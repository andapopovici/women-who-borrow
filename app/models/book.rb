class Book < ApplicationRecord
  has_and_belongs_to_many :tags
  has_one :reservation, dependent: :destroy
  belongs_to :user, foreign_key: "user_id"

  before_update :check_status_for_update
  before_destroy :check_status_for_deletion

  STATUSES = [
    AVAILABLE = 'available',
    RESERVED = 'reserved',
    BORROWED = 'borrowed'
  ]

  validates :status, :inclusion => { :in => STATUSES }, :allow_blank => false

  scope :borrowed, -> { where(status: BORROWED) }
  scope :reserved, -> { where(status: RESERVED) }

  def belongs_to?(user)
    self.user == user
  end

  def is_available?
    status == AVAILABLE
  end

  def available_to_borrow_by?(user)
    status == AVAILABLE && !belongs_to?(user)
  end

  def reserved_by?(user)
    status == RESERVED && reservation.user == user
  end

  def borrower
    reservation.user
  end

  def is_reserved?
    reservation && status == RESERVED
  end

  def is_borrowed?
    reservation && status == BORROWED
  end

  private

  def check_status_for_update
    if status != AVAILABLE && (status_change == nil)
      self.errors[:status] << "This book has been #{status} and cannot be edited"
      throw :abort
    end
  end

  def check_status_for_deletion
    if status != AVAILABLE
      self.errors[:status] << "This book has been #{status} and cannot be deleted"
      throw :abort
    end
  end

end
