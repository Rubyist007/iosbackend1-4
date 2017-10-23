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

  def report
    return render json: {status: 422, errors: "You must provide subject"} if params[:subject] == nil
    return render json: {status: 422, errors: "You must provide text"} if params[:text] == nil

    ReportMailer.report(params[:subject], params[:text], currnet_user).deliver
    render json: { data: 'Done' }
  end

  def feed
    return render json: {status: 422, errors: "You must provide distance"} if request.headers["distance"] == nil
    #if request.headers["time"] != nil && request.headers["count"] != nil
    #  render json: {data: current_user.feed(Restaurant, 
    #                                        request.headers["distance"], 
    #                                      ((request.headers["count"].to_i).send(request.headers["time"]).ago),
    #                                       [current_user.latitude, current_user.longitude])}
    #else
      render json: {data: current_user.feed(Restaurant, 
                                            request.headers["distance"], 
                                            3.month.ago,
                                           [current_user.latitude, current_user.longitude])}

    #end
  end
end

