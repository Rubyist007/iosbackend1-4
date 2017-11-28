class OverrideDeviceController::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController

  def omniauth_success
    get_resource_from_auth_hash
    create_token_info
    set_token_on_resource
    create_auth_params

    if resource_class.devise_modules.include?(:confirmable)
      # don't send confirmation email!!!
      @resource.skip_confirmation!
    end

    sign_in(:user, @resource, store: false, bypass: false)

    @resource.save!

    resource_with_token = JSON::parse(@resource.to_json).merge({"access_token" => @token, "client" => @client_id})

    render json: { data: [ resource_with_token ] }
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

  def get_resource_from_auth_hash
    # find or create user by provider and provider uid
    @resource = resource_class.where({
      uid:      auth_hash['uid'],
      provider: auth_hash['provider']
    }).first_or_initialize

    if @resource.new_record?
      @oauth_registration = true
      set_random_password
    end

    # sync user info with provider, update/generate auth token
    assign_provider_attrs(@resource, auth_hash)

    # assign any additional (whitelisted) attributes
    extra_params = whitelisted_params
    @resource.assign_attributes(extra_params) if extra_params
 
    @resource
  end

  def assign_provider_attrs(user, auth_hash)
    attrs = auth_hash['info'].to_hash.slice(*user.attributes.keys)
    user.assign_attributes(attrs)
  end
end
