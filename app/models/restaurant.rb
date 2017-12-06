class Restaurant < ApplicationRecord
  include ValidatesCoordinate

  has_many :dishes
  
  after_validation :reverse_geocode

  reverse_geocoded_by :latitude, :longitude do |restaurant, results|
    if geo = results.first
      restaurant.address = geo.address
      restaurant.street = geo.address.split(",")[0].strip
      restaurant.city = geo.city
      restaurant.state = geo.state
    end
  end
  
  validates_presence_of :title, :description, :latitude, :longitude#, [photos]

  validates :title, length: { maximum: 50 }

  validates :description, length: { minimum: 10, maximum: 500 } 

  validates_length_of :photos, maximum: 10, too_long: "You can't upload more than 10 photo"

  mount_base64_uploaders :photos, PhotosRestaurantUploader
end
