class OverrideDeviceController::PasswordsController < DeviseTokenAuth::PasswordsController
  before_action :set_user_by_token, :only => [:update]
  skip_after_action :update_auth_header, :only => [:create, :edit]

  def update

    p "!!!!!!!!!!!!!!!!!!!!!!!!"
    p params
    p params[:password]
    p params[:password_confirmation]
    #Devise::Encryptor.compare()
    p "!!!!!!!!!!!!!!!!!!!!!!!!"

    # make sure user is authorized
    unless @resource
      return render_update_error_unauthorized
    end

    # make sure account doesn't use oauth2 provider
    unless @resource.provider == 'email'
      return render_update_error_password_not_required
    end

    

    # make sure reset_password_token right
    #unless params[:reset_password_token] == @resource.reset_password_token
    #  return render json: "wrong reset_password_token"
    #end

    # ensure that password params were sent
    
    #unless params[:password] && params[:password_confirmation]
    #  return render_update_error_missing_password
    #end

    if @resource.update_without_password(password: params[:password], password_confirmation: params[:password])
      @resource.allow_password_change = true
      @resource.save!
      yield @resource if block_given?
      return render_update_success
    else
      return render_update_error
    end
  end
end


