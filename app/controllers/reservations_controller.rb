class ReservationsController < ApplicationController
  before_action :require_login
  before_action :set_book, only: [:new, :create, :show, :destroy]
  before_action :set_reservation, only: [:show, :destroy]
  before_action :require_authorization, :only => [:create]


  def new
    @reservation = Reservation.new
  end

  def create

    #Don't allow user to pass anyone else's details when creating a reservation
    return if params[:user]

    @reservation = Reservation.new(book: @book, user: current_user)
    @book.reserve
    if @book.errors.any?
      @reservation.errors.add(:base, "Unable to reserve this book.")
    end
    respond_to do |format|
      if @reservation.errors.empty? && @reservation.save
        format.html { redirect_to book_path(@book), notice: "Reservation was successfully created." }
        format.json { render json: @reservation, status: :created, location: @reservation }
      else
        format.html { redirect_to book_path(@book), notice: @reservation.errors.full_messages.to_s.tr('[]"', '') }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # Don't allow user to destroy other user's reservation unless they own the book
    unless (current_user == @reservation.user) || (current_user == @reservation.book.user)
      return
    end

    respond_to do |format|
      if @reservation.destroy
        format.html { redirect_to book_path(@book), notice: "Reservation was successfully destroyed." }
        format.json { head :no_content }
        @book.unreserve
      else
        format.html { render :show }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def require_authorization
    redirect_to book_path(@book) unless @book.available_to_borrow_by?(current_user)
  end
end
