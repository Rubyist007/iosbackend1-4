class Restaurant < ApplicationRecord
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

  validates :description, length: { minimum: 100, maximum: 500 }

  validate :validate_latitude
  validate :validate_longitude

  mount_base64_uploaders :photos, PhotosRestaurantUploader

  private
    
    def validate_latitude
      latitude = self.latitude.to_s
      return true if latitude.blank?
      return false if latitude.match(/\A(\+|-)?(?:90(?:(?:\.0{1,6})?)|(?:[0-9]|[1-8][0-9])(?:(?:\.[0-9]{1,6})?))\z/) == nil
    end

    def validate_longitude
      longitude = self.longitude.to_s
      return true if latitude.blank?
      return false if longitude.match(/\A(\+|-)?(?:180(?:(?:\.0{1,6})?)|(?:[0-9]|[1-9][0-9]|1[0-7][0-9])(?:(?:\.[0-9]{1,6})?))\z/) == nil
    end
end
