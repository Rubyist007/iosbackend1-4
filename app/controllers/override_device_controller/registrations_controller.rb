class OverrideDeviceController::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def render_create_error
    render json: { status: 422, error: resource_errors[:full_messages] }, status: 422
  end
end
