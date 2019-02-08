class Book < ApplicationRecord
  has_and_belongs_to_many :tags
  belongs_to :user, foreign_key: "user_id"

  STATUSES = [
    FREE = 'free',
    RESERVED = 'reserved',
    BORROWED = 'borrowed'
  ]

  validates :status, :inclusion => { :in => STATUSES }, :allow_blank => false

  def belongs_to?(current_user)
  	user == current_user
  end

end
