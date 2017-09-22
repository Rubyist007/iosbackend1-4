class Admin < ApplicationRecord
  devise :database_authenticatable, :recoverable, 
         :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
end
