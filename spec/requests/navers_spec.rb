require 'rails_helper'

RSpec.describe "Navers", type: :request do
  describe "requests with authenticated user" do
    login_user
    describe "/index" do
      before :each do
        create_list(:naver, rand(1...20), user: @user)
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
        expect(response.body).to eq(NaverWithRelationsSerializer.new(@naver, { include: [:projects] }).serializable_hash.to_json)
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
        @new_naver = build(:naver, id: old_naver.id, user: nil)
        patch "/naver/update", params: @new_naver.attributes, headers: @token
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns updated naver" do
        result = eval(response.body)[:data][:attributes]
        expect(result[:name]).to eq(@new_naver.name)
        expect(result[:birthdate]).to eq(@new_naver.birthdate.to_s)
        expect(result[:admission_date]).to eq(@new_naver.admission_date.to_s)
        expect(result[:job_role]).to eq(@new_naver.job_role)
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
  describe "requests with authenticated user" do
    before :each do
      @naver = create(:naver)
    end

    it "/index" do
      get "/naver/index"
      expect(response).to have_http_status(:unauthorized)
    end
    
    it "/show" do
      get "/naver/show/#{@naver.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it "/store" do
      post "/naver/store", params: @naver.attributes
      expect(response).to have_http_status(:unauthorized)
    end

    it "/update" do
      new_nave = build(:naver)
      patch "/naver/update", params: new_nave.attributes
      expect(response).to have_http_status(:unauthorized)
    end

    it "/delete" do 
      delete "/naver/delete/#{@naver.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
