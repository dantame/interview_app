# frozen_string_literal: true

describe AuthorizeApiRequest do
  let!(:user) { create(:user) }
  subject(:context) { described_class.call({ "Authorization" => authorization }) }

  describe ".call" do
    context "when the context is successful" do
      let(:authorization) { AuthenticateUser.call(user.username, user.password).result }

      it "succeeds" do
        expect(context).to be_success
      end
    end

    context "when the context is not successful" do
      let(:authorization) { "incorrect" }

      it "fails" do
        expect(context).to be_failure
      end
    end
  end
end
