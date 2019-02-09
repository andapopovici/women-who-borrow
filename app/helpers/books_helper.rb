module BooksHelper

  def friendly_status(book)
    friendly_status = book.status.capitalize
    unless book.status == Book::FREE
      friendly_status += " by #{book.reservation.user.email}"
    end
    friendly_status
  end
end
