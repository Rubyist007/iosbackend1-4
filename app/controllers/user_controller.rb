class UserController < ApplicationController
  
 before_action :authenticate_user!, only: [:index, :show, :feed]
 before_action :current_user_admin?, only: [:ban]

  def index
    render json: {data: User.all}
  end

  def show 
    render json: {data: User.find(params[:id])}
  rescue ActiveRecord::RecordNotFound
    render json: {status: 404, errors: ["Couldn't find User with 'id'=#{params[:id]}"]}, status: 404
  end

  def thank
    render json: "Thank for confirm email!"
  end

  def resend_confirmation
    user = User.where(email: request.headers["email"])
    user[0].resend_confirmation_instructions
    render json: {status: 200, data: "Resend success."}
    rescue NoMethodError
      render json: {status: 404, errors: ["Couldn't find User with 'email'=#{request.headers["email"]}"]}, status: 404
  end

  def ban
    user = User.find(params[:id])
    time = params[:count].send(:day).after
    user.update_attribute(:ban_time, time)

    render json: user
  end

  def feed
    p '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    p current_user
    return render json: {status: 422, errors: "You must provide distance"} if request.headers["distance"] == nil
   
    render json: {data: current_user.feed(Restaurant, 
                                            request.headers["distance"], 
                                            3.month.ago,
                                           [current_user.latitude, current_user.longitude])}
  end
end

