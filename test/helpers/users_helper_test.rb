require 'test_helper'

class UsersHelperTest < ActionView::TestCase

  def setup
    @user = User.create!({
      first_name: "Jane",
      last_name: "Eyre",
      email: "jane_eyre@example.com",
      password: "password",
    })

    @book1 = Book.create!({
      title: "Pragmatic Programmer",
      author: "Andy Hunt",
      edition: "1",
      year: 1999,
      isbn: "9780201616224",
      user: users(:user_one),
      status: Book::AVAILABLE
    })
  end

  test "retrieves books reserved by user" do
    @reservation = Reservation.create!(user: @user, book: @book1)
    @book1.update(status: Book::RESERVED)

    assert_includes(books_reserved_by(@user), @book1)
  end

  test "retrieves books borrowed by user" do
    @reservation = Reservation.create!(user: @user, book: @book1)
    @book1.update(status: Book::BORROWED)

    assert_includes(books_borrowed_by(@user), @book1)
  end
end
