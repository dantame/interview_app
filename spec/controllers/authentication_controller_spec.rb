# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthenticationController do
  let!(:user) { create(:user) }

  describe "POST #authenticate" do
    it "returns an authorization jwt for a valid user" do
      post :authenticate, params: { username: "test", password: "test" }
      expect(JSON.parse(response.body)).to have_key("auth_token")
    end

    it "returns an error for invalid credentials" do
      post :authenticate, params: { username: "notreal", password: "test" }
      expect(JSON.parse(response.body)).to eq({ "error" => { "user_authentication" => "invalid credentials" } })
    end
  end

  describe "POST #create" do
    it "returns an authorization jwt after creating a user" do
      post :create, params: { username: "created_user", password: "test", password_confirmation: "test" }
      expect(JSON.parse(response.body)).to have_key("auth_token")
    end

    it "returns an error for invalid params" do
      post :create, params: { username: "notreal", pass: "test" }
      expect(JSON.parse(response.body)).to eq({ "error" => "Unable to create user" })
    end
  end
end
