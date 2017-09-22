require 'rails_helper'

RSpec.describe RelationshipController, type: :controller do
  
  before(:all) do
    @user_id_1 = create(:user, :email_0)
    @user_id_2 = create(:user, :email_1)
  end

  describe 'POST /relationship' do
    it "user can follow another user" do
      request.headers.merge! @user_id_1.create_new_auth_token
      post :create, params: {followed_id: 2}

      expect(response.body).to eq(@user_id_1.following?(@user_id_2).to_json)
    end

    it "user can`t follow not exist user" do 
      request.headers.merge! @user_id_1.create_new_auth_token

      expect(lambda {post :create, params: {followed_id: 3}}).to raise_exception(ActiveRecord::RecordNotFound)
    end

    it "user can`t twice follow user" do
      request.headers.merge! @user_id_1.create_new_auth_token
      post :create, params: {followed_id: 2}

      expect(lambda {post :create, params: {followed_id: 2}
}).to raise_exception(ActiveRecord::RecordNotUnique)
    end
  end

  describe 'DELETE /relarionship/:id' do
    it "User can unfollow another user" do 
      request.headers.merge! @user_id_1.create_new_auth_token
      post :create, params: {followed_id: 2}

      request.headers.merge! @user_id_1.create_new_auth_token
      delete :destroy, params: {id: 2}
      expect(@user_id_1.following?(@user_id_2)).to eq(nil)
    end
    
    it "user can`t unfollow not exist user" do
      request.headers.merge! @user_id_1.create_new_auth_token
      
      expect(lambda {delete :destroy, params: {id: 3}}).to raise_exception(ActiveRecord::RecordNotFound)
    end

    it "user can`t twice unfollow user" do
      request.headers.merge! @user_id_1.create_new_auth_token

      post :create, params: {followed_id: 2}

      request.headers.merge! @user_id_1.create_new_auth_token
      delete :destroy, params: {id: 2}

      request.headers.merge! @user_id_1.create_new_auth_token
      expect(lambda {delete :destroy, params: {id: 2}}).to raise_exception(NoMethodError)
    end
  end
end
