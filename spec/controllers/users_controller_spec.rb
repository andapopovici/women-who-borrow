require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

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
      expect(User.where(email: "ewa_l@example.com")).to_not be_present
    end

    it "should be able to view user show page" do
      get :show, params: { id: user.id }

      expect(response).to have_http_status(200)
    end

    it "should be able to view edit form for self" do
      get :edit, params: {  id: user.id }

      expect(response).to have_http_status(200)
    end

    it "should not be able to view edit form for others" do
      get :edit, params: {  id: other_user.id }

      expect(response).to have_http_status(302)
    end

    it "should be able to update own details" do
      new_email = "hello@example.com"

      put :update, params: { id: user.id, user: {
        email: new_email
      } }

      expect(response).to redirect_to user
      expect(flash[:notice]).to eq("User was successfully updated.")
      expect(user.reload).to have_attributes(email: new_email)
    end

    it "should not be able to update other users" do
      old_email = user.email
      new_email = "hello@example.com"

      put :update, params: { id: other_user.id, user: {
        email: new_email
      } }

      expect(response).to redirect_to other_user
      expect(user.reload).to have_attributes(email: old_email)
      expect(flash.keys).to be_empty
    end

    it "should be able to destroy self" do
      delete :destroy, params: { id: user.id }

      expect{ User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(sign_in_url)
      expect(flash[:notice]).to eq("Your account was successfully deleted.")
    end

    it "should not be able to destroy others" do
      delete :destroy, params: { id: other_user.id }

      expect(User.find(other_user.id)).to be_present
      expect(response).to redirect_to(other_user)
      expect(flash.keys).to be_empty
    end
  end

  context "when not signed in" do
    it "should not be able to get index" do
      get :index

      expect(response).to deny_access(redirect: sign_in_url)
    end

    it "should not be able to view user show page" do
      get :show, params: { id: user.id }

      expect(response).to deny_access(redirect: sign_in_url)
    end

    it "should not be able to update user details" do
      new_email = "hello@example.com"

      put :update, params: { id: user.id, user: {
        email: new_email
      } }

      expect(response).to deny_access(redirect: sign_in_url)
    end

    it "should not be able to destroy user" do
      delete :destroy, params: { id: user.id }

      expect(response).to deny_access(redirect: sign_in_url)
    end
  end
end
