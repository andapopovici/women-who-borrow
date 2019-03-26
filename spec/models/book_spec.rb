require 'rails_helper'

RSpec.describe Book, type: :model do

  describe "associations" do
    it { is_expected.to have_one(:reservation).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_inclusion_of(:status).in_array(Book::STATUSES) }
  end

  context "when reserved" do
    let(:reserved_book) { create(:book, :reserved) }

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
    let(:borrowed_book) { create(:book, :borrowed) }

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
    let(:available_book) { create(:book) }

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

  describe "#check_for_reservation_changes" do
    let(:user) { create(:user) }

    context "when a User reserves a Book" do
      let(:available_book) { create(:book) }

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
      let(:borrowed_book) { create(:book, :borrowed) }

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
