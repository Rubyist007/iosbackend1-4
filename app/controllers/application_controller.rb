class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :set_cache_control

  def current_user_admin?
    if current_user == nil
      render json: { status: 402, errors: ["You need to sign in or sign up before continuing"] }, status: 402
    elsif current_user.admin == true
      true
    else
      render json: { errors: ['This can do only admin'] }
    end
  end

  def authenticate!
    if current_user != nil
      true
    else
      render json: { status: 402, errors: ["You need to sign in or sign up before continuing"] }, status: 402
    end
  end
  
  def not_ban_user 
    if current_user.ban_time < Time.now
      true
    else
     render json: { errors: "You are banned until #{Time.parse(current_user.ban_time).strftime("%B %d, %Y")}" }, status: 401
    end
  end
  
  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, 
                                                                :last_name, 
                                                                :latitude, 
                                                                :longitude, 
                                                                :avatar, 
                                                                :number_phone,])
    end

    def set_cache_control
      response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate"
    end
end

