class Restaurant < ApplicationRecord
  has_many :dishes
  geocoded_by :address
  validates_presence_of :title, :description, :state, :city#, [photos]

  validates :title, length: { maximum: 50 }

  validates :description, length: { minimum: 100, maximum: 500 }

  mount_base64_uploader :facade, FacadeUploader
  mount_base64_uploader :logo, LogoUploader
end
