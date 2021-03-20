require 'rails_helper'

RSpec.describe "Projects", type: :request do
  describe "requests with authenticated user" do
    login_user
    describe "/index" do
      before :each do
        create_list(:project, rand(1...20), user: @user)
        get "/project/index", headers: @token
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "returns all projects" do
        result = eval(response.body)[:data]
        expect(result.length).to eq(@user.projects.length)
      end
    end

    describe "/show" do
      before :each do
        @project = create(:project, user: @user)
        get "/project/show/#{@project.id}", headers: @token
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "returns project" do
        expect(response.body).to eq(ProjectWithRelationsSerializer.new(@project, { include: [:navers] }).serializable_hash.to_json)
      end
    end

    describe "/store" do
      before :each do
        @project = build(:project, user: nil)
        post "/project/store", params: @project.attributes, headers: @token
      end

      it "returns http created" do
        expect(response).to have_http_status(:created)
      end

      it "returns stored project" do
        result = eval(response.body)[:data]
        expect(result[:id]).to_not be_empty
      end
    end

    describe "/update" do
      before :each do
        old_project = create(:project, user: @user)
        @new_project = build(:project, id: old_project.id, user: nil)
        patch "/project/update", params: @new_project.attributes, headers: @token
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns updated project" do
        result = eval(response.body)[:data][:attributes]
        expect(result[:name]).to eq(@new_project.name)
      end
    end

    describe "/delete" do
      before :each do
        @project = create(:project, user: @user)
        delete "/project/delete/#{@project.id}", headers: @token
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "delete project" do
        expect(@user.projects).to_not include(@project)
      end
    end
  end

  describe "requests with authenticated user" do
    before :each do
      @project = create(:project)
    end

    it "/index" do
      get "/project/index"
      expect(response).to have_http_status(:unauthorized)
    end

    it "/show" do
      get "/project/show/#{@project.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it "/store" do
      post "/project/store", params: @project.attributes
      expect(response).to have_http_status(:unauthorized)
    end

    it "/update" do
      new_nave = build(:project)
      patch "/project/update", params: new_nave.attributes
      expect(response).to have_http_status(:unauthorized)
    end

    it "/delete" do 
      delete "/project/delete/#{@project.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
