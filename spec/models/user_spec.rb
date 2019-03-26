require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { FactoryBot.create(:user) }

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

end
