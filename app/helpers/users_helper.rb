module UsersHelper

  def books_reserved_by(user)
    reserved_or_borrowed_by(user).reserved
  end

  def books_borrowed_by(user)
    reserved_or_borrowed_by(user).borrowed
  end

  private

  def reserved_or_borrowed_by(user)
    Book.joins(:reservation).where("reservations.user_id = ?", user.id)
  end
end
