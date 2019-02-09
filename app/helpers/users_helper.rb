module UsersHelper

  def reserved_books(user)
    reserved_or_borrowed(user).select { |b| b.status == Book::RESERVED }
  end

  def borrowed_books(user)
    reserved_or_borrowed(user).select { |b| b.status == Book::BORROWED }
  end

  private

  def reserved_or_borrowed(user)
    user.reservations.map(&:book)
  end
end
