class UserController < ApplicationController
  
 before_action :authenticate_user!, only: [:index, :show, :news]

  def index
    render json: {data: User.all}
  end

  def show 
    render json: {data: User.find(params[:id])}
  rescue ActiveRecord::RecordNotFound
    render json: {status: 404, errors: "Couldn't find User with 'id'=#{params[:id]}"}, status: 404
  end

  def thank
    render json: "Thank for confirm email!"
  end

  def update
    #update user 
  end

  def resend_confirmation
    user = User.where(uid: request.headers["email"])
    p user
    user.resend_confirmation_instructions
  end

  def feed
    return render json: {status: 422, errors: "You must provide distance"} if request.headers["distance"] == nil
   
    render json: {data: current_user.feed(Restaurant, 
                                            request.headers["distance"], 
                                            3.month.ago,
                                           [current_user.latitude, current_user.longitude])}
  end
end

