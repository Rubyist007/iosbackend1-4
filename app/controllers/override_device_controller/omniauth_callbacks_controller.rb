class OverrideDeviceController::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController

  def redirect_callbacks
    # derive target redirect route from 'resource_class' param, which was set
    # before authentication.
    devise_mapping = [request.env['omniauth.params']['namespace_name'],
                      request.env['omniauth.params']['resource_class'].underscore.gsub('/', '_')].compact.join('_')
    path = "#{Devise.mappings[devise_mapping.to_sym].fullpath}/#{params[:provider]}/callback"
    klass = request.scheme == 'https' ? URI::HTTPS : URI::HTTP
    redirect_route = klass.build(host: request.host, port: request.port, path: path).to_s

    # preserve omniauth info for success route. ignore 'extra' in twitter
    # auth response to avoid CookieOverflow.
    session['dta.omniauth.auth'] = request.env['omniauth.auth'].except('extra')
    session['dta.omniauth.params'] = request.env['omniauth.params']

    #p '__________________________________________'
    #p request.env['omniauth.params']
    #p '__________________________________________'
    #p request.env['omniauth.auth']
    #p '__________________________________________'
    #p redirect_route
    #p '__________________________________________'

    redirect_to redirect_route	
  end

  def omniauth_success
    get_resource_from_auth_hash
    create_token_info
    set_token_on_resource
    create_auth_params

    auth_header = @auth_params

    if resource_class.devise_modules.include?(:confirmable)
      # don't send confirmation email!!!
      @resource.skip_confirmation!
    end

    sign_in(:user, @resource, store: false, bypass: false)

    @resource.save!

    auth_header.stringify_keys!

    response.headers.merge!(auth_header)

    render json: @resource, status: 200
  end

  def create_auth_params
    @auth_params = {
      access_token: @token,
      client:  @client_id,
      uid:        @resource.uid,
      expiry:     @expiry,
      config:     @config
    }
    @auth_params.merge!(oauth_registration: true) if @oauth_registration
    @auth_params
  end
end
