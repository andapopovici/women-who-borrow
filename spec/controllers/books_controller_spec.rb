require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:book) { create(:book) }
  let(:user) { create(:user) }

  context "when signed in" do
    before :each do
      sign_in_as(user)
    end

    it "should be able to get index" do
      get :index
      expect(response).to have_http_status(200)
    end

    it "should be able to get new" do
      get :new
      expect(response).to have_http_status(200)
    end

    it "should be able to create book" do
      post :create, params: { book: {
        author: book.author,
        edition: book.edition,
        isbn: book.isbn,
        title: book.title,
        year: book.year,
        status: book.status,
        user: book.user
      } }

      expect(response).to redirect_to Book.last
    end

    it "should be able to view book show page" do
      get :show, params: { id: book.id }
      expect(response).to have_http_status(200)
    end

    it "should be able to get edit" do
      get :edit, params: {  id: book.id }
      expect(response).to have_http_status(200)
    end

    it "should be able to update book" do
      new_title = "Small Gods"

      put :update, params: { id: book.id, book: {
        title: new_title
      } }

      expect(response).to redirect_to book
      expect(book.reload).to have_attributes(title: new_title)
    end

    it "should be able to destroy book" do
      delete :destroy, params: {  id: book.id }
      assert !Book.exists?(book.id)
      expect(response).to redirect_to(books_url)
    end
  end
end
