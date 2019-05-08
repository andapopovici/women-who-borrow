module BooksHelper

  def status(book)
    if book.is_available?
      "Available"
    elsif book.is_reserved?
      "Reserved"
    elsif book.is_borrowed?
      "Borrowed"
    end
  end
end
