require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the BooksHelper. For example:
#
# describe BooksHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe BooksHelper, type: :helper do

  describe "#status" do
    let(:available_book) { create(:book) }
    let(:reserved_book) { create(:book, :reserved) }
    let(:borrowed_book) { create(:book, :borrowed) }

    it "returns Available for books with no reservation" do
      expect(status(available_book)).to eq("Available")
    end

    it "returns Reserved for books with unapproved reservation" do
      expect(status(reserved_book)).to eq("Reserved")
    end

    it "returns Borrowed for books with approved reservation" do
      expect(status(borrowed_book)).to eq("Borrowed")
    end
  end
end
