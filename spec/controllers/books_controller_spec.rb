require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:book) { create(:book) }
  let(:user) { create(:user) }
  let(:users_book) { create(:book, user: user) }
  let(:other_user) { create(:user) }

  context "when signed in" do
    before :each do
      sign_in_as(user)
    end

    it "should be able to get index" do
      get :index

      expect(response).to have_http_status(200)
    end

    it "should be able to get new book form" do
      get :new

      expect(response).to have_http_status(200)
    end

    it "should be able to create their own book" do
      post :create, params: { book: {
        author: book.author,
        edition: book.edition,
        isbn: book.isbn,
        title: book.title,
        year: book.year,
        status: book.status,
        user: user
      } }

      expect(user.books.count).to eq(1)
      expect(flash[:notice]).to eq("Book was successfully created.")
    end

    it "should not be able to create book for other users" do
      post :create, params: { book: {
        author: book.author,
        edition: book.edition,
        isbn: book.isbn,
        title: book.title,
        year: book.year,
        status: book.status,
        user: other_user
      } }
      expect(other_user.books.count).to eq(0)
    end

    it "should be able to view book show page" do
      get :show, params: { id: book.id }

      expect(response).to have_http_status(200)
    end

    it "should be able to get edit for book they own" do
      get :edit, params: {  id: users_book.id }

      expect(response).to have_http_status(200)
    end

    it "should not be able to get edit for book they don't own" do
      get :edit, params: {  id: book.id }

      expect(response).to redirect_to book_url
    end

    it "should not be able to update a book" do
      new_status = Book::RESERVED

      put :update, params: { id: book.id, book: {
        status: new_status
      } }

      expect(response).to redirect_to book
      expect(book.reload).to have_attributes(status: new_status)
      expect(flash.notice).to eq("Book was successfully updated.")
    end

    it "should be able to destroy own book" do
      delete :destroy, params: { id: users_book.id }

      expect{ Book.find(users_book.id) }.to raise_error(
        ActiveRecord::RecordNotFound
      )
      expect(response).to redirect_to(books_url)
      expect(flash[:notice]).to eq("Book was successfully destroyed.")
    end

    it "should not be able to destroy other user's book" do
      delete :destroy, params: { id: book.id }

      expect(Book.find(book.id)).to be_present
      expect(response).to redirect_to(book_url)
      expect(flash.keys).to be_empty
    end
  end

  context "when not signed in" do
    it "should not be able to get index" do
      get :index

      expect(response).to deny_access(redirect: sign_in_url)
    end

    it "should not be able to view book show page" do
      get :show, params: { id: user.id }

      expect(response).to deny_access(redirect: sign_in_url)
    end

    it "should not be able to update book details" do
      new_title = "Small Gods"

      put :update, params: { id: book.id, book: {
        title: new_title
      } }

      expect(response).to deny_access(redirect: sign_in_url)
    end

    it "should not be able to destroy book" do
      delete :destroy, params: { id: book.id }

      expect(response).to deny_access(redirect: sign_in_url)
    end
  end
end
