module ValidatesCoordinate
  extend ActiveSupport::Concern

  included do
    validate :validate_latitude, on: :update
    validate :validate_longitude, on: :update
  end

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
