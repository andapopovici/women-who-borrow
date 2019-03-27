require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, type: :helper do
  let(:user) { create(:user) }

  describe "#books_reserved_by" do
    let(:reserved_book) { create(:book, :reserved).tap do |book|
      book.reservation.update(user: user)
    end
    }

    it "retrieves books reserved by user" do
      expect(books_reserved_by(user)).to eq([reserved_book])
    end
  end

  describe "#books_borrowed_by" do
    let(:borrowed_book) { create(:book, :borrowed).tap do |book|
      book.reservation.update(user: user)
    end
    }

    it "retrieves books borrowed by user" do
      borrowed_book.reservation.update(user: user)
      expect(books_borrowed_by(user)).to eq([borrowed_book])
    end
  end
end
