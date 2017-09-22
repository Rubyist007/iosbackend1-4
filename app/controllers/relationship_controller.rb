class RelationshipController < ApplicationController

  #before_action :authenticate_user! 

  def create
    follower = current_user 
    followed = User.find(params[:followed_id])
    render json: follower.follow!(followed)
  end

  def show
    render json: User.find(params[:id]).followed_users
  end

  def destroy
    follower = current_user
    followed = User.find(params[:id])
    render json: follower.unfollow!(followed)
  end
end
