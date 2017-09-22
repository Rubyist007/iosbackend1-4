require 'rails_helper'

RSpec.describe DishController, type: :controller do

  before(:all) do
    create(:restaurant, :good, :rivne)

    @dish_id_1 = create(:dish, :restaurant_one)
    @dish_id_2 = create(:dish, :restaurant_one)

    @user_id_1 = create(:user, :email_0)

    @auth_header = @user_id_1.create_new_auth_token
  end

  describe 'GET /dish/:id' do
    it "show dish on id 1" do
      request.headers.merge! @auth_header
      get :show, params: { id: 1 }
      expect(response.body).to eq(@dish_id_1.to_json)
    end

    it "show dish on id 2" do
      request.headers.merge! @auth_header
      get :show, params: { id: 2 }
      expect(response.body).to eq(@dish_id_2.to_json)
    end

    it "error dish not exist" do 
      request.headers.merge! @auth_header
      expect(lambda { get :show, params: { id: 3 } }).to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST /restaurant/:restaurant_id/dish' do 
    it "success create dish" do
      request.headers.merge! @auth_header
      expect{post :create, params: {restaurant_id: 1,
                                    dish:{ name: "dish three", 
                                           description: "description" * 10 }}}.to change(Dish, :count).by(1)
    end

    it "reject create dish" do 
      request.headers.merge! @auth_header
      expect{post :create, params: {restaurant_id: 1,
                                    dish:{ name: "dish three"*10, 
                                           description: "description" }}}.to_not change(Dish, :count)
    end
  end

  describe "GET /restaurant/:restaurant_id/" do
    it "get all dish restaurant" do
      request.headers.merge! @auth_header
      get :index, params: { restaurant_id: 1 }
      expect(response.body).to eq([@dish_id_1, @dish_id_2].to_json)
    end
    
    it "error not exist restaurant" do
      request.headers.merge! @auth_header
      expect(lambda { get :index, params: { restaurant_id: 2 } }).to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
