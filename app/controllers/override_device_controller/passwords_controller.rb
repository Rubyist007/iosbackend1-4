class OverrideDeviceController::PasswordsController < DeviseTokenAuth::PasswordsController
  before_action :set_user_by_token, :only => []
  skip_after_action :update_auth_header, :only => [:create, :edit]

  def update
    @resource = User.where(uid: params[:email]).first

    # make sure account doesn't use oauth2 provider
    unless @resource.provider == 'email'
      return render_update_error_password_not_required
    end

    # make sure reset_password_token right

    token = Devise.token_generator.digest(User, :reset_password_token, params[:reset_password_token])

    unless token == @resource.reset_password_token
      return render json: { errors: "wrong reset_password_token" }
    end

    # ensure that password params were sent
    unless params[:password] && params[:password_confirmation]
      return render_update_error_missing_password
    end

    if @resource.update_attributes(password: params[:password])
      @resource.allow_password_change = true
      @resource.save!
      yield @resource if block_given?
      return render_update_success
    else
      return render_update_error
    end
  end

  def render_update_success 
    render json: { data: [@resource] }
  end
end


