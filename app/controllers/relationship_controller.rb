class RelationshipController < ApplicationController

  def create
    follower = User.find(params[:follower_id])
    followed = User.find(params[:followed_id])
    render json: follower.follow!(followed)
  end

  def show
    render json: User.find(params[:id]).followed_users
  end

  def destroy
    follower = User.find(params[:follower_id])
    followed = User.find(params[:followed_id])
    render json: follower.unfollow!(followed)
  end
end
