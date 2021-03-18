require 'rails_helper'

RSpec.describe Naver, type: :model do
  describe "Valid naver" do 
    it "with all atributes" do
      naver = build(:naver)
      expect(naver).to be_valid
    end
  end
end
