require 'test_helper'

class BookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:user_one)
  end

  test 'valid book' do
    book = Book.new(title: "Pragmatic Programmer", author: "Andy Hunt", edition: "1", year: 1999, isbn: "9780201616224", user:@user, status:"available")
    assert book.valid?
  end
end
