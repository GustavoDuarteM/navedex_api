require 'rails_helper'

RSpec.describe "SignUps", type: :request do
  describe "Sign Up" do
    it "returns http success" do
      user = build(:user)
      post "/sign_up", params: { email: user.email, password: user.password }
      expect(response).to have_http_status(:success)
    end
  end

end
