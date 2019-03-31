class ReservationsController < ApplicationController
  before_action :set_book, only: [:new, :create, :show, :destroy]
  before_action :set_reservation, only: [:show, :destroy]

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(book: @book, user: current_user)
    @book.reserve
    if @book.errors.any?
      @reservation.errors.add(:base, "Unable to reserve this book.")
    end
    respond_to do |format|
      if @reservation.errors.empty? && @reservation.save
        format.html { redirect_to book_path(@book), notice: "Reservaton was successfully created." }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { redirect_to book_path(@book), notice: @reservation.errors.full_messages.to_s.tr('[]"', '') }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @reservation.destroy
        format.html { redirect_to book_path(@book), notice: 'Reservation was successfully destroyed.' }
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
end
