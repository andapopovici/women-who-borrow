class User < ApplicationRecord
  include Clearance::User

  has_many :books, dependent: :destroy
  has_many :reservations

  def reserved_books
  	reservations.map(&:book)
  end

  def reserve(book)
    if book.update_attributes(status: Book::RESERVED)
      reservation = Reservation.new(user: self, book: book)
      reservation.save
    end
  end

  def unreserve(book)
    if book.reservation && book.update_attributes(status: Book::FREE)
      book.reservation.destroy
    end
  end
end
