require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  context "when signed in" do
    before :each do
      sign_in_as(user)
    end

    it "should be able to get index" do
      get :index
      expect(response).to have_http_status(200)
    end

    it "should not be able access new user form" do
      get :new
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end

    it "should not be able to create new user" do
      post :create, params: { user: {
        first_name: "Ewa",
        last_name: "Lipinska",
        email: "ewa_l@example.com",
        password: "password"
      } }

      expect(response).to have_http_status(302)
      assert !User.where(email: "ewa_l@example.com").exists?
    end

    it "should be able to view user show page" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(200)
    end

    it "should be able to view edit form for self" do
      get :edit, params: {  id: user.id }
      expect(response).to have_http_status(200)
    end

    it "should not be able to view edit form for others"

    it "should be able to update own details" do
      new_email = "hello@example.com"

      put :update, params: { id: user.id, user: {
        email: new_email
      } }

      expect(response).to redirect_to user
      expect(user.reload).to have_attributes(email: new_email)
    end

    it "should not be able to update other users"

     it "should be able to destroy self" do
      delete :destroy, params: { id: user.id }
      assert !User.exists?(user.id)
      expect(response).to redirect_to(sign_in_url)
    end

     it "should not be able to destroy others"
  end
end
