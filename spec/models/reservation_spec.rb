require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:book) }
  end

  describe "#approved?" do
    let(:reservation) { create(:reservation) }
    let(:approved_reservation) { create(:reservation, :approved) }

    it "returns true for approved reservation" do
      expect(approved_reservation.approved?).to be true
    end

    it "returns false for reservation which hasn't been approved" do
      expect(reservation.approved?).to be false
    end
  end
end
