module BooksHelper

  def capitalized_status(book)
    book.status.capitalize
  end
end
