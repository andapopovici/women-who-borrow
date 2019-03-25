require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:book_one)
    @user = users(:user_one)
  end

  test "should get index" do
    get books_url(as: @user)
    assert_response :success
  end

  test "should get new" do
    get new_book_url(as: @user)
    assert_response :success
  end

  test "should create book" do
    assert_difference('Book.count') do
      post books_url(as: @user), params: { book: { author: @book.author, edition: @book.edition, isbn: @book.isbn, title: @book.title, year: @book.year, status: @book.status, user: @book.user } }
    end

    assert_redirected_to book_url(Book.last)
  end

  test "should show book" do
    get book_url(@book, as: @user)
    assert_response :success
  end

  test "should get edit" do
    get edit_book_url(@book, as: @user)
    assert_response :success
  end

  test "should update book" do
    patch book_url(@book, as: @user), params: { book: { author: @book.author, edition: @book.edition, isbn: @book.isbn, title: @book.title, year: @book.year } }
    assert_redirected_to book_url(@book)
  end

  test "should destroy book" do
    assert_difference('Book.count', -1) do
      delete book_url(@book, as: @user)
    end

    assert_redirected_to books_url
  end
end
