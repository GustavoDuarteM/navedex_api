require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "Valid project" do 
    it "with all atributes" do
      naver = build(:project)
      expect(naver).to be_valid
    end
  end
end
