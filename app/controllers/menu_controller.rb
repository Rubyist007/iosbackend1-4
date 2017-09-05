class MenuController < ApplicationController
  def create
    menu =  Restaurant.first.create_menu
    menu.save
    render json: menu
  end

  def show
    render json: Restaurant.find(params[:id]).menu
  end
end
