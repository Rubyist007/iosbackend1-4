class OverrideDeviceController::SessionsController < DeviseTokenAuth::SessionsController

  def render_create_success
    render json: {data: [@resource]}
  end

  def render_create_error_bad_credentials 
    render json: { status: 401, errors: ["Invalid login credentials. Please try again."] }, status: 401
  end
  
  def render_create_error_not_confirmed
    render json: { status: 401, errors: ["A confirmation email was sent to your account at '#{@resource.email}'. You must follow the instructions in the email before your account can be activated"] }, status: 401
  end
end
