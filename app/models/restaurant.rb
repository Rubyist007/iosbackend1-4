class Restaurant < ApplicationRecord
  has_many :dishes
  has_one :global_rating
  geocoded_by :address
  validates_presence_of :title, :description#, :main_photo

  validates :title, length: { maximum: 50 }

  validates :description, length: { minimum: 100, maximum: 500 }

  mount_uploader :facade, FacadeUploader
  mount_uploader :logo, LogoUploader

end
