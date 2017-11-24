class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  #after_commit :show_header
  after_action :no_store

  def current_user_admin?
    if current_user == nil
      render json: { status: 402, errors: ["You need to sign in or sign up before continuing"] }, status: 402

    elsif current_user.admin == true
      return true
    else
      render json: { errors: ['This can do only admin'] }
    end
  end

  def authenticate!
    if current_user != nil
      return true
    else
      render json: { status: 402, errors: ["You need to sign in or sign up before continuing"] }, status: 402
      false
    end
  end
  
  def not_ban_user
    p Time.now
    p current_user.ban_time
    p current_user.ban_time < Time.now

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
                                                                :number_phone,
                                                                :password,
                                                                :password_confirmation])
    end

    def show_header
      p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      p response.headers#["access-token"] 
      p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    end

    def no_store
      response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate"
    end
end

