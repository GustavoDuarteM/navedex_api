require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Valid user" do 
    it "with emal and password" do
      user = build(:user)
      expect(user).to be_valid
    end
  end
  describe "Invalid user" do 
    it "Invalid email" do
      user = build(:user, email: Faker::Internet.username)
      expect(user).to_not be_valid
    end
  end
end
