require 'rails_helper'

RSpec.describe "Navers", type: :request do
  login_user
  describe "/index" do
    before :each do
      10.times{ create(:naver, user: @user) }
      get "/naver/index", headers: @token
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "returns all navers" do
      result = eval(response.body)[:data]
      expect(result.length).to eq(@user.navers.length)
    end
  end

  describe "/show" do
    before :each do
      @naver = create(:naver, user: @user)
      get "/naver/show/#{@naver.id}", headers: @token
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "returns naver" do
      expect(response.body).to eq(NaverWithRelationsSerializer.new(@naver).serializable_hash.to_json)
    end
  end

  describe "/store" do
    before :each do
      @naver = build(:naver, user: nil)
      post "/naver/store", params: @naver.attributes, headers: @token
    end

    it "returns http created" do
      expect(response).to have_http_status(:created)
    end

    it "returns stored naver" do
      result = eval(response.body)[:data]
      expect(result[:id]).to_not be_empty
    end
  end

  describe "/update" do
    before :each do
      old_naver = create(:naver, user: @user)
      @new_nave = build(:naver, id: old_naver.id, user: nil)
      patch "/naver/update", params: @new_nave.attributes, headers: @token
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns updated naver" do
      result = eval(response.body)[:data][:attributes]
      expect(result[:name]).to eq(@new_nave.name)
      expect(result[:birthdate]).to eq(@new_nave.birthdate.to_s)
      expect(result[:admission_date]).to eq(@new_nave.admission_date.to_s)
      expect(result[:job_role]).to eq(@new_nave.job_role)
    end
  end

  describe "/delete" do
    before :each do
      @naver = create(:naver, user: @user)
      delete "/naver/delete/#{@naver.id}", headers: @token
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "delete naver" do
      expect(@user.navers).to_not include(@naver)
    end
  end

end
