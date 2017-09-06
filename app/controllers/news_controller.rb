class NewsController < ApplicationController
  
  def show
    p User.find(params[:id]).news
    render json: User.find(params[:id]).news
  end
end
