# frozen_string_literal: true

require "rails_helper"

RSpec.describe NewsController do
  it_behaves_like "an authorized endpoint" do
    let(:endpoint) { :sentiment_for_news }
    let(:params) { { search_term: "foo" } }
  end

  let!(:user) { create(:user) }
  let(:auth_token) { AuthenticateUser.call(user.username, user.password).result }

  describe "GET #sentiment_for_news" do
    it "returns a list of headlines with sentiment score" do
      request.headers["Authorization"] = "Bearer #{auth_token}"
      get :sentiment_for_news, params: { search_term: "foo" }

      expect(JSON.parse(response.body)).to be_an_instance_of Array
      expect(JSON.parse(response.body).first).to have_key("headline")
      expect(JSON.parse(response.body).first).to have_key("sentiment_score")
    end

    it "returns an empty array if the 3rd party api is down" do
      stub_request(:get, /newsapi.org/).
        with(
          headers: {
           "Accept"=>"*/*",
           "User-Agent"=>"Ruby"
          }).
        to_return(status: 500, body: "", headers: {})
      request.headers["Authorization"] = "Bearer #{auth_token}"
      get :sentiment_for_news, params: { search_term: "foo" }

      expect(JSON.parse(response.body)).to be_an_instance_of Array
      expect(JSON.parse(response.body)).to be_empty
    end

    it "returns an empty array if no articles are returned" do
      stub_request(:get, /newsapi.org/).
        with(
          headers: {
           "Accept"=>"*/*",
           "User-Agent"=>"Ruby"
          }).
        to_return(status: 200, body: "{\"articles\": []}", headers: {})
      request.headers["Authorization"] = "Bearer #{auth_token}"
      get :sentiment_for_news, params: { search_term: "foo" }

      expect(JSON.parse(response.body)).to be_an_instance_of Array
      expect(JSON.parse(response.body)).to be_empty
    end
  end
end
