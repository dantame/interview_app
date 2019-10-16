# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthenticateUser do
  let!(:user) { create(:user) }
  subject(:context) { described_class.call(username, password) }

  describe ".call" do
    context "when the context is successful" do
      let(:username) { "test" }
      let(:password) { "test" }

      it "succeeds" do
        expect(context).to be_success
      end
    end

    context "when the context is not successful" do
      let(:username) { "wrong_user" }
      let(:password) { "wrong_password" }

      it "fails" do
        expect(context).to be_failure
      end
    end
  end
end
