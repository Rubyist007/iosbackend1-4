class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def current_user_admin?
    true if current_user.admin == true
  end
end
