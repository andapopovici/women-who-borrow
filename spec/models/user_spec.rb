require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe "associations" do
    it { is_expected.to have_many(:reservations).dependent(:destroy) }
    it { is_expected.to have_many(:books).dependent(:destroy) }
  end

  describe "#friendly_name" do
    it "should return a friendly name for user" do
      friendly_name = "#{ user.first_name.capitalize } "\
      "#{ user.last_name.capitalize }"

      expect(user.friendly_name).to eq friendly_name
    end
  end

  describe "#is_editable_by?" do
    it "returns true for self" do
      expect(user.is_editable_by?(user)).to be true
    end

    it "returns false for other users" do
      expect(user.is_editable_by?(other_user)).to be false
    end
  end

end
