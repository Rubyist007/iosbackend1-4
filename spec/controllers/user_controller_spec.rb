require 'rails_helper'

RSpec.describe UserController, type: :controller do
  before(:all) do
    @user_id_1 = create(:user, :email_0)
    @user_id_2 = create(:user, :email_1)

    @restaurant_id_1 = create(:restaurant, :good, :rivne)
    @restaurant_id_2 = create(:restaurant, :bad, :ostrog)

    @dish_id_1 = create(:dish, :restaurant_one)
    @dish_id_2 = create(:dish, :restaurant_one)
    @dish_id_3 = create(:dish, :restaurant_two) 

    @evaluation_id_1 = create(:evaluation, 
                              :user_two, 
                              :dish_one, 
                              :restaurant_one)

    @evaluation_id_2 = create(:evaluation, 
                              :user_two, 
                              :dish_two, 
                              :restaurant_one)

    @evaluation_id_3 = create(:evaluation, 
                              :user_two, 
                              :dish_three, 
                              :restaurant_two)
      end

  describe '/user' do 
    it "show all user" do
      get :index
      expect(response.body).to eq([@user_id_1, @user_id_2].to_json)
    end
  end

  describe '/user/:id' do
    it "show user on id 1" do
      get :show, params: { id: 1 }
      expect(response.body).to eq(@user_id_1.to_json)
    end

    it "show user on id 2" do
      get :show, params: { id: 2 }
      expect(response.body).to eq(@user_id_2.to_json)
    end

    it "error user not exist" do 
      expect(lambda { get :show, params: { id: 3 } }).to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  describe '/user/news' do
    it "user dont see own evaluations" do
      auth_header =  @user_id_1.create_new_auth_token
      request.headers.merge! auth_header
      post :news, params: { distance: 1, count: 5, time: 'week'}
      expect(response.body).to eq([].to_json)
    end

    it "user see last 20 evaluations followed user" do
      @user_id_1.follow!(@user_id_2)    
      auth_header =  @user_id_1.create_new_auth_token
      request.headers.merge! auth_header
      post :news, params: { distance: 1, count: 5, time: 'week'}
      expect(response.body).to eq([[@evaluation_id_3, 
                                    @restaurant_id_2, 
                                    @dish_id_3,
                                    @user_id_2],
                                   [@evaluation_id_2, 
                                    @restaurant_id_1, 
                                    @dish_id_2,
                                    @user_id_2],
                                   [@evaluation_id_1, 
                                    @restaurant_id_1, 
                                    @dish_id_1,
                                    @user_id_2]].to_json)
    end

    it "user can see evaluations folowed user and good restaurant in some radius" do
      @user_id_1.follow!(@user_id_2)    
      auth_header =  @user_id_1.create_new_auth_token
      request.headers.merge! auth_header
      post :news, params: { distance: 1, count: 5, time: 'week', coordinate: true}
      expect(response.body).to eq([[[@evaluation_id_2,
                                    @restaurant_id_1, 
                                    @dish_id_2,
                                    @user_id_2],
                                   [@evaluation_id_1, 
                                    @restaurant_id_1, 
                                    @dish_id_1,
                                    @user_id_2]],
                                   [@restaurant_id_1]].to_json)
    end
  end
end
