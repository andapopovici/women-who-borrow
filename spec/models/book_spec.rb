require 'rails_helper'

RSpec.describe Book, type: :model do

  let(:available_book) { create(:book) }
  let(:reserved_book) { create(:book, :reserved) }
  let(:borrowed_book) { create(:book, :borrowed) }

  let(:user) { create(:user) }

  describe "associations" do
    it { is_expected.to have_one(:reservation).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_inclusion_of(:status).in_array(Book::STATUSES) }
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
      expect(Book.borrowed.where_values_hash).to eq(
        { "status" => Book::BORROWED }
        )
    end
  end

  describe "reserved scope" do
    it "only returns reserved books" do
      expect(Book.reserved.where_values_hash).to eq(
        { "status" => Book::RESERVED }
        )
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

  describe "#check_for_reservation_changes" do
    context "when a User reserves a Book" do
      it "creates a new reservation" do
        available_book.check_for_reservation_changes(
          old_status: Book::AVAILABLE,
          new_status: Book::RESERVED,
          user: user
          )

        expect(available_book.reservation).to be_present
      end
    end

    context "when a Book is returned" do
      it "destroys reservation" do
        borrowed_book.check_for_reservation_changes(
          old_status: Book::BORROWED,
          new_status: Book::AVAILABLE,
          user: user
          )

        expect(borrowed_book.reservation).to be_present
      end
    end
  end
end
