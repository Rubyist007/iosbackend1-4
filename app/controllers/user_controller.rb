class UserController < ApplicationController
  
 #before_action :authenticate_user!, only: [:index, :show, :news]

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

  def news
    render json: {data: current_user.news(Restaurant, 
                                   params[:distance], 
                                   ((params[:count].to_i).send(params[:time]).ago|| 1.month.ago),
                                   (params[:coordinate] || false))}
  end
end

