class UserController < ApplicationController
  
 # before_action :authenticate_user!  

  def index
    render json: User.all
  end

  def show 
    render json: User.find(params[:id])
  end

  def thank
    render json: "Thank for confirm email!"
  end

  def news
    render json: current_user.news(Restaurant, 
                                   params[:distance], 
                                   ((params[:count].to_i).send(params[:time]).ago|| 1.month.ago),
                                   (params[:coordinate] || false))
  end

  def update
    current_user.update_attributes(user_params)
  end

  private 

    def user_params
      params.require(:user).permit(:name, :avatar, :nickname, :latitude, :longitude)
    end
end

