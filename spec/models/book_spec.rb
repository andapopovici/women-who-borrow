require 'rails_helper'

RSpec.describe Book, type: :model do

  let(:available_book) { create(:book) }
  let(:reserved_book) { create(:book, :reserved) }
  let(:borrowed_book) { create(:book, :borrowed) }

  let(:user) { create(:user) }

  describe "associations" do
    it { is_expected.to have_one(:reservation).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
  end

  describe "checking status in callbacks" do
    context "when reserved" do
      it "cannot be edited" do
        new_title = "Small Gods"

        expect {
          reserved_book.update(title: new_title)
        }.to_not change{ reserved_book.reload.title }
      end

      it "cannot be destroyed" do
        reserved_book.destroy

        expect(Book.where(:id => reserved_book.id)).to be_present
      end
    end

    context "when borrowed" do
      it "cannot be edited" do
        new_title = "Small Gods"

        expect {
          borrowed_book.update(title: new_title)
        }.to_not change{ borrowed_book.reload.title }
      end

      it "cannot be destroyed" do
        borrowed_book.destroy

        expect(Book.where(:id => borrowed_book.id)).to be_present
      end
    end

    context "when available" do
      it "can be edited" do
        old_title = available_book.title
        new_title = "Small Gods"

        expect {
          available_book.update(title: new_title)
        }.to change{ available_book.reload.title }
        .from(old_title).to(new_title)
      end

      it "can be destroyed" do
        available_book.destroy

        expect(Book.where(:id => available_book.id)).to_not be_present
      end
    end
  end

  describe "borrowed scope" do
    it "only returns borrowed books" do
      borrowed_book
      expect(Book.borrowed.count).to eq(1)
      expect(Book.borrowed).to include(borrowed_book)
    end
  end

  describe "reserved scope" do
    it "only returns reserved books" do
      reserved_book
      expect(Book.reserved.count).to eq(1)
      expect(Book.reserved).to include(reserved_book)
    end
  end

  describe "#available_to_borrow_by?" do
    context "when the user owns the book" do
      it "returns false" do
        owner = available_book.user

        expect(available_book.available_to_borrow_by?(owner)).to be false
      end
    end

    context "when the user doesn't own the book" do
      it "only returns true for an available book" do
        expect(available_book.available_to_borrow_by?(user)).to be true
        expect(reserved_book.available_to_borrow_by?(user)).to be false
        expect(borrowed_book.available_to_borrow_by?(user)).to be false
      end
    end
  end

  describe "#reserved_by?" do
    context "if a book isn't reserved" do
      it "returns false" do
        expect(available_book.reserved_by?(user)).to be false
      end
    end

    context "if a book is reserved" do
      it "returns true for the user who holds the reservation" do
        reservation_holder = reserved_book.reservation.user

        expect(reserved_book.reserved_by?(reservation_holder)).to be true
      end

      it "returns false for any other user" do
        expect(reserved_book.reserved_by?(user)).to be false
      end
    end
    context "if a book is borrowed" do
      it "returns false" do
        borrower = borrowed_book.reservation.user

        expect(borrowed_book.reserved_by?(borrower)).to be false
      end
    end
  end

  describe "#belongs_to" do
    it "returns true for the book owner" do
      owner = available_book.user

      expect(available_book.belongs_to?(owner)).to be true
    end

    it "returns false for any other user" do
      other_user = user

      expect(available_book.belongs_to?(other_user)).to be false
    end
  end

  describe "#borrower" do
    it "returns the user associated with book reservation" do
      borrower = reserved_book.reservation.user

      expect(reserved_book.borrower).to eq(borrower)
    end
  end

  describe "#is_available?" do
    it "returns true for a book with no reservation" do
      expect(available_book.is_available?).to be true
    end

    it "returns false for a reserved book" do
      expect(reserved_book.is_available?).to be false
    end

    it "returns false for a borrowed book" do
      expect(borrowed_book.is_available?).to be false
    end
  end

  describe "#is_reserved?" do
    it "returns true for a reserved book" do
      expect(reserved_book.is_reserved?).to be true
    end

    it "returns false for a book with no reservation" do
      expect(available_book.is_reserved?).to be false
    end

    it "returns false for a borrowed book" do
      expect(borrowed_book.is_reserved?).to be false
    end
  end


  describe "#is_borrowed?" do
    it "returns true for a borrowed book" do
      expect(borrowed_book.is_borrowed?).to be true
    end

    it "returns false for a reserved book" do
      expect(reserved_book.is_borrowed?).to be false
    end

    it "returns false for a book with no reservation" do
      expect(available_book.is_borrowed?).to be false
    end
  end


  describe "#is_editable_by?" do
    it "returns true for a book the user owns" do
      owner = available_book.user
      expect(available_book.is_editable_by?(owner)).to be true
    end

    it "returns false the user doesn't own" do
      expect(available_book.is_editable_by?(user)).to be false
    end
  end
end
