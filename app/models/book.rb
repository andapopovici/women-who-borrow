class Book < ApplicationRecord
  has_and_belongs_to_many :tags
  has_one :reservation, dependent: :destroy
  belongs_to :user, foreign_key: "user_id"

  before_update :check_status_for_update
  before_destroy :check_status_for_deletion

  scope :borrowed, -> { joins(:reservation).where.not(reservations: { approved_at: nil }) }
  scope :reserved, -> { joins(:reservation).where(reservations: { approved_at: nil }) }

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
    !reservation
  end

  def is_reserved?
    reservation.present? && !reservation.approved?
  end

  def is_borrowed?
    reservation.present? && reservation.approved?
  end

  def is_editable_by?(user)
    self.user == user
  end

  private

  def check_status_for_update
    if reservation
      self.errors.add(:base, "This book cannot be edited")
      throw :abort
    end
  end

  def check_status_for_deletion
    if reservation
      self.errors.add(:base, "This book cannot be deleted")
      throw :abort
    end
  end

end
