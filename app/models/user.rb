class User < ApplicationRecord
  include Clearance::User

  has_many :books, dependent: :destroy
  has_many :reservations

  def reserve(book)
    book.update_attributes(status: Book::RESERVED)
  end

  def unreserve(book)
    if book.reservation && book.update_attributes(status: Book::FREE)
      book.reservation.destroy
    end
  end
end
