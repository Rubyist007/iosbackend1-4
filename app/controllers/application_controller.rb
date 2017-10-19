class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :no_store!

  def current_user_admin?
    true if current_user.admin == true
  end

  def authenticate!
    if current_user != nil
      return true
    else
      render json: { status: 422, errors: ["You need to sign in or sign up before continuing"] }, status: 402
      false
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
                                                                :number_phone])
    end

    def no_store!
      response.headers["Cache-Control"] = "no-store"
    end
end

