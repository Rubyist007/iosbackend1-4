class OverrideDeviceController::PasswordsController < DeviseTokenAuth::PasswordsController
  before_action :set_user_by_token, :only => [:update]
  skip_after_action :update_auth_header, :only => [:create, :edit]

  # this action is responsible for generating password reset tokens and
  # sending emails
  def create
    unless resource_params[:email]
      return render_create_error_missing_email
    end

    # give redirect value from params priority
    @redirect_url = params[:redirect_url]

    # fall back to default value if provided
    @redirect_url ||= DeviseTokenAuth.default_password_reset_url

    unless @redirect_url
      return render_create_error_missing_redirect_url
    end

    # if whitelist is set, validate redirect_url against whitelist
    if DeviseTokenAuth.redirect_whitelist
      unless DeviseTokenAuth::Url.whitelisted?(@redirect_url)
        return render_create_error_not_allowed_redirect_url
      end
    end

    @email = get_case_insensitive_field_from_resource_params(:email)
    @resource = find_resource(:uid, @email)

    if @resource
      yield @resource if block_given?
      @resource.send_reset_password_instructions({
        email: @email,
        provider: 'email',
        redirect_url: @redirect_url,
        client_config: params[:config_name]
      })

      if @resource.errors.empty?
        return render_create_success
      else
        render_create_error @resource.errors
      end
    else
      render_not_found_error
    end
  end

  def update
    # make sure user is authorized
    unless @resource
      return render_update_error_unauthorized
    end

    # make sure account doesn't use oauth2 provider
    unless @resource.provider == 'email'
      return render_update_error_password_not_required
    end

    # ensure that password params were sent
    unless password_resource_params[:password] && password_resource_params[:password_confirmation]
      return render_update_error_missing_password
    end

    if @resource.send(resource_update_method, password_resource_params)
      @resource.allow_password_change = false if recoverable_enabled?
      @resource.save!
      yield @resource if block_given?
     return render_update_success
      else
        return render_update_error
    end
  end
end

