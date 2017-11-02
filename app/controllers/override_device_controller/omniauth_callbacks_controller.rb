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

    p '__________________________________________'
    p request.env['omniauth.params']
    p '__________________________________________'
    p request.env['omniauth.auth']
    p '__________________________________________'
    p redirect_route
    p '__________________________________________'

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

    p auth_header
    auth_header.stringify_keys!
    #auth_header['Location'] = 'r8ProdUrl://'
    p auth_header


    #new_auth_header = @resource.create_new_auth_token
    response.headers.merge!(auth_header)
    #response.headers.merge!({'Location' => '/'})

    render json: @resource#, status: 303
    #redirect_to 'r8ProdUrl://'
  end


  def send_resource resource

  end
end
