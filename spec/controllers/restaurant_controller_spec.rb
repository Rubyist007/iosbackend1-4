require 'rails_helper'

RSpec.describe RestaurantController, type: :controller do

  before(:all) do
    @restaurant_id_1 = create(:restaurant, :bad, :rivne)
    @restaurant_id_2 = create(:restaurant, :good, :ostrog)

    @user = create(:user, :email_1)  
  end


  describe 'GET /restaurant/:id' do
    it "show restaurant on id 1" do
      request.headers.merge! @user.create_new_auth_token

      get :show, params: { id: 1 }
      expect(response.body).to eq(@restaurant_id_1.to_json)
    end

    it "show restaurant on id 2" do
      request.headers.merge! @user.create_new_auth_token

      get :show, params: { id: 2 }
      expect(response.body).to eq(@restaurant_id_2.to_json)
    end

    it "error dish not exist" do 
      request.headers.merge! @user.create_new_auth_token

      expect(lambda { get :show, params: { id: 3 } }).to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST /restaurant' do 
    it "success create restaurant" do
      request.headers.merge! @user.create_new_auth_token

      expect {post :create, params: { restaurant: { title: "48/7",
                                                    description: "description"*15}}}.to change(Restaurant, :count).by(1)
    end

    it "reject create dich" do
      request.headers.merge! @user.create_new_auth_token

       expect {post :create, params: { restaurant: { description: "description"*15}}}.to_not change(Restaurant, :count) 
    end
  end

  describe 'GET /restaurant' do
    it "show first 10 restaurant" do
      request.headers.merge! @user.create_new_auth_token

      # inside test we create 2 restoraunt
      # so we have only 2 restaurant rather than 10
      get :index
      expect(response.body).to eq([@restaurant_id_1, @restaurant_id_2].to_json)
    end
  end

  describe 'POST /restaurant/common_top_hundred' do
    it "show top 100 restaurantn" do 
      request.headers.merge! @user.create_new_auth_token

      # again we have only two
      get :top_hundred
      expect(response.body).to eq([@restaurant_id_2, @restaurant_id_1].to_json)
    end
  end

  describe 'POST /restaurant/top_ten_in_region' do
    it "get top restaurant in state" do 
      request.headers.merge! @user.create_new_auth_token

      post :top_ten_in_region, params: { state: "Rivnenska Obl." }
      expect(response.body).to eq([@restaurant_id_2, @restaurant_id_1].to_json)
    end

    it "get top restaurant in state in city" do
      request.headers.merge! @user.create_new_auth_token

      post :top_ten_in_region, params: { state: "Rivnenska Obl.", city: "Rivne" }
      expect(response.body).to eq([@restaurant_id_1].to_json)
    end

    it "have error when dont set state" do
      request.headers.merge! @user.create_new_auth_token

      expect(lambda { post :top_ten_in_region, params: { city: 'Ostrog' }
}).to raise_exception("Dont have state")
    end
  end

  describe 'POST /restaurant/near' do
    it "show near 1 mile restaurants from coordinate user" do
      request.headers.merge! @user.create_new_auth_token

      post :near, params: {distance: 1}
      parse_response = JSON.parse(response.body)
      expect(parse_response.first["id"]).to eq(@restaurant_id_1.id)
      expect(parse_response.length).to eq(1)
    end

    it "show near 2 mile restaurant from coordinate user" do 
      request.headers.merge! @user.create_new_auth_token

      post :near, params: {distance: 25}
      parse_response = JSON.parse(response.body)
      expect([parse_response.first["id"], 
              parse_response.second["id"]]).to eq([@restaurant_id_1.id, 
                                                   @restaurant_id_2.id])
      expect(parse_response.length).to eq(2)
    end

    it "get error if dont have distance" do
      request.headers.merge! @user.create_new_auth_token

      expect(lambda { post :near }).to raise_exception("Dont have distance")
    end
  end
end
