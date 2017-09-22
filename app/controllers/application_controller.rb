class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def authenticate_any!
    if admin_signed_in?
      true
    else
      authenticate_user!
    end
  end
end
