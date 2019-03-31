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

  def available_to_borrow_by?(user)
    is_available? && !belongs_to?(user)
  end

  def reserved_by?(user)
    if (is_reserved? && borrower == user)
      true
    else
      false
    end
  end

  def belongs_to?(user)
    self.user == user
  end

  def borrower
    reservation.user
  end

  def is_available?
    status == AVAILABLE
  end

  def is_reserved?
    reservation && status == RESERVED
  end

  def is_borrowed?
    reservation && status == BORROWED
  end

  def is_editable_by?(user)
    self.user == user
  end

  def reserve
    if is_available?
      update_attributes(status: RESERVED)
    else
      self.errors.add(:base, "This book cannot be reserved")
    end
  end

  def unreserve
    update_attributes(status: AVAILABLE)
  end

  private

  def check_status_for_update
    if status != AVAILABLE && (status_change == nil)
      self.errors.add(:status, "This book has been #{status} and cannot be edited")
      throw :abort
    end
  end

  def check_status_for_deletion
    if status != AVAILABLE
      self.errors.add(:status, "This book has been #{status} and cannot be deleted")
      throw :abort
    end
  end

end
