require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do

  let(:book) { create(:book) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:reservation) { create(:reservation) }

  context "when signed in" do
    before :each do
      sign_in_as(user)
    end

    it "should be able to get new reservation form" do
      get :new, params: { book_id: book.id }

      expect(response).to have_http_status(200)
    end

    it "should be able to reserve a book" do
      post :create, params: { book_id: book.id }

      expect(book.reservation).to be_present
      expect(flash[:notice]).to eq(
        "Reservation was successfully created."
        )
    end

    it "should not be able to make a reservation for a different user" do
      post :create, params: { book_id: book.id, user: other_user }

      expect(book.reservation).to be_nil
    end

    it "should be able to update a reservation" do
      reserved_book = create(:book, :reserved)
      reservation = reserved_book.reservation

      timestamp = Time.now

      put :update, params: { book_id: reserved_book.id, id: reservation.id, reservation: { approved_at: timestamp } }

      expect(response).to redirect_to book_path(reserved_book)
      expect(reservation.reload.approved_at.to_s).to eq(timestamp.utc.to_s)
      expect(flash.notice).to eq("Reservation was successfully updated.")
    end

    it "should be able to cancel their own reservation" do
      reserved_book = create(:book, :reserved)
      reservation = reserved_book.reservation
      reservation.user = user
      reservation.save

      delete :destroy, params: {
        book_id: reserved_book.id,
        id: reservation.id
      }

      expect(response).to redirect_to(book_path(reserved_book))
      expect(flash[:notice]).to eq("Reservation was successfully destroyed.")
      expect(reserved_book.reload.reservation).to be_nil
    end

    it "should be able to cancel a reservation if they own the book" do
      reserved_book = create(:book, :reserved).tap do |book|
        book.update_column(:user_id, user.id)
      end
      reservation = reserved_book.reservation

      delete :destroy, params: {
        book_id: reserved_book.id,
        id: reservation.id
      }

      expect(response).to redirect_to(book_path(reserved_book))
      expect(flash[:notice]).to eq("Reservation was successfully destroyed.")
      expect(reserved_book.reload.reservation).to be_nil
    end

    it "should not be able to cancel a reservation for another user" do
      reserved_book = create(:book, :reserved)
      delete :destroy, params: {
        book_id: reserved_book.id,
        id: reserved_book.reservation.id
      }

      expect(reserved_book.reload.reservation).to be_present
    end
  end

  context "when not signed in" do
    it "should not be able to get new" do
      get :new, params: { book_id: book.id }

      expect(response).to deny_access(redirect: sign_in_url)
    end

    it "should not be able to create a reservation" do
      post :create, params: { book_id: book.id }

      expect(response).to deny_access(redirect: sign_in_url)
    end

    it "should not be able to update a reservation" do
      reserved_book = create(:book, :reserved)
      reservation = reserved_book.reservation

      put :update, params: { book_id: reserved_book.id, id: reservation.id, reservation: { approved_at: Time.now } }

      expect(response).to deny_access(redirect: sign_in_url)
    end

    it "should not be able to destroy book" do
      delete :destroy, params: {
        book_id: reservation.book.id,
        id: reservation.id
      }

      expect(response).to deny_access(redirect: sign_in_url)
    end
  end
end
