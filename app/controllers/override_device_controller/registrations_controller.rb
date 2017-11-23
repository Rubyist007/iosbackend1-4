class OverrideDeviceController::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def render_create_success
    render json: {data: [@resource]}
  end

  def render_create_error
    render json: { status: 422, errors: resource_errors[:full_messages] }, status: 422
  end

  #def render_create_success
  #  render json: { status: 201, Data: @resource}
  #end
end
