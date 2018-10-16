json.extract! book, :id, :title, :author, :edition, :year, :isbn, :created_at, :updated_at
json.url book_url(book, format: :json)
