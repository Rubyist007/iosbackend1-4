require 'rails_helper'

RSpec.describe EvaluationController, type: :controller do  
  before(:all) do
    @user_id_1 = create(:user, :email_0)
    @user_id_2 = create(:user, :email_1)

    @restaurant_id_1 = create(:restaurant, :null_rating, :rivne)

    @dish_id_1 = create(:dish, :restaurant_one)
    @dish_id_2 = create(:dish, :restaurant_one) 
    
    @auth_header = @user_id_1.create_new_auth_token
  end

  describe 'POST /evaluation' do
    it "user can create evaluation and automatic update rating restaurant" do
      request.headers.merge! @auth_header
      post :create, params: {evaluation: {dish_id: 1, evaluation: 4.5}}, as: :json

      @restaurant_id_1.reload

      # check create evaluation
      expect(Evaluation.count).to eq(1)
      # check update rating restaurant
      expect(@restaurant_id_1.number_of_ratings).to eq(1)
      expect(@restaurant_id_1.sum_ratings).to eq(4.5)
      expect(@restaurant_id_1.average_ratings).to eq(4.5)
      expect(@restaurant_id_1.actual_rating.round(2)).to eq(3.52)
    end


    it "user can create evaluation and automatic update rating dish" do
      request.headers.merge! @auth_header
      post :create, params: {evaluation: {dish_id: 1, evaluation: 4.5}}, as: :json

      @dish_id_1.reload

      # check create evaluation
      expect(Evaluation.count).to eq(1)
      # check update rating dish
      expect(@dish_id_1.number_of_ratings).to eq(1)
      expect(@dish_id_1.sum_ratings).to eq(4.5)
      expect(@dish_id_1.average_ratings).to eq(4.5)
      expect(@dish_id_1.actual_rating.round(2)).to eq(3.52)
    end

    it "user can create evaluation and automatic update statistic user" do
      auth_header = @user_id_1.create_new_auth_token
      request.headers.merge! auth_header
      post :create, params: {evaluation: {dish_id: 1, evaluation: 4.5}}, as: :json

      @user_id_1.reload

      # check create evaluation
      expect(Evaluation.count).to eq(1)
      # check update statistics user
      expect(@user_id_1.number_of_evaluations).to eq(1)
      expect(@user_id_1.sum_ratings_of_evaluations).to eq(4.5)
      expect(@user_id_1.average_ratings_evaluations).to eq(4.5)
    end
  end
end
