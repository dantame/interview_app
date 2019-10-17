# frozen_string_literal: true

shared_examples "an authorized endpoint" do
  let!(:user) { create(:user) }
  let(:http_verb) { method(:get) }
  let(:endpoint) { :foo }
  let(:params) { {} }
  let(:auth_token) { AuthenticateUser.call(user.username, user.password).result }

  context "has authorisation headers" do
    it "allows access to the endpoint" do
      request.headers["Authorization"] = "Bearer #{auth_token}"
      http_verb.call(endpoint, params: params)
      expect(response.status).to eq(200)
    end
  end

  context "does not have authorisation headers" do
    it "blocks access to the endpoint" do
      request.headers["Authorization"] = nil
      http_verb.call(endpoint, params: params)
      expect(response.status).to eq(401)
    end
  end
end
