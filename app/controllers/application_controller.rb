class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :set_cache_control 
  
  protected

    def current_user_admin!
      if current_user.admin == true
        true
      else
        render json: { status: 403, errors: ['This can do only admin'] }, status: 403
      end
    end 

    def not_banned_user!
      if current_user.ban_time < Time.now
        true
      else
       render json: { status: 403, errors: "You are banned until #{Time.parse(current_user.ban_time).strftime("%B %d, %Y")}" }, status: 403
      end
    end

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

    def not_find_by_id(model, id)
      render json: { status: 404, errors: "Couldn't find #{model} with 'id'=#{id}" }, status: 404
    end

    def render_errors_422(errors)
      render json: { status: 422, errors: errors }, status: 422
    end
end
