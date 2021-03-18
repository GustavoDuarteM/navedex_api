require 'rails_helper'

RSpec.describe "Logins", type: :request do
  describe "Login" do
    it "returns http success" do
      user = create(:user)
      post "/login", params: { email: user.email, password: user.password }
      expect(response).to have_http_status(:success)
    end
  end
end
