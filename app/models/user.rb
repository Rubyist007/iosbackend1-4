class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable, :confirmable

  include DeviseTokenAuth::Concerns::User
  include Geocoder::Calculations

  validates_presence_of :email, :password, :first_name, :last_name, on: :create

  validates_format_of :password, with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{6,128}\z/, allow_blank: true
  #validates_length_of [:first_name, :last_name], in: 2..30
  #validates_length_of :email, in: 6..72
  validates_length_of :number_phone, is: 12, on: :update, allow_blank: true
  validates :latitude, numericality: { only_float: true }, on: :update, allow_blank: true
  validates :longitude, numericality: { only_float: true }, on: :update, allow_blank: true

  validate :validate_latitude, on: :update
  validate :validate_longitude, on: :update

  has_and_belongs_to_many :evaluation

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy

  has_many :reports

  mount_base64_uploader :avatar, AvatarUploader

  def my_evaluations
    result = []

    evaluations = self.evaluation.order('updated_at DESC')

    p evaluations
    
    evaluations.each do |evaluation|
      e = evaluation
      d = Dish.find(evaluation.dish_id)
      r = Restaurant.find(evaluation.restaurant_id)

      p e
      p d
      p r
      
      result << [e, r, d]
    end

    result
  end

  def feed restaurant_class, distance, time, coordinate
    #evaluation = Evaluation.from_users_followed_by(self, time)
    #evaluation_dish = Dish.find(evaluation.map { |e| e.dish_id })
    
    if coordinate
      #restaurant_from_evaluation = restaurant_class.find(evaluation.map { |e| e.restaurant_id })

      #near_restaurant_from_evaluation = []
      #near_restaurant_id_from_evaluation = []
      #p '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
      near_restaurant = Restaurant.near(coordinate, distance)

      evaluation = []
      dishes = []
      result = []

      near_restaurant.each do |r|
        p '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
        next if r.dishes.count == 0
        #p r.dishes.count
        p offset = rand(r.dishes.count)
        p dishes << r.dishes.offset(offset).first
        p '**************************************************'
      end

      dishes.each do |d|
          p '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          p d
          p '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          #evaluation << d.evaluation
          evaluation << d.evaluation.where("updated_at >= :time", 
          time: time).limit(1).order("updated_at DESC") || next
          #p '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
          p d.evaluation
        end

      return "Feed empty" if evaluation.blank? 

      evaluation.each do |e|
        #p e
        #p e[0].user_id
        #e[0].restaurant_id
        r = restaurant_class.find(e[0].restaurant_id)
        p dishes[0].id
        p dishes[1].id
        p '-'
        p e[0].dish_id
        p e[0]

        d = dishes.find { |dish| dish.id == e[0].dish_id }
        #d = dishes.find { |dish| p dish  }
        u = self.class.find(e[0].user_id)
        result << [e[0], r, d, u]
      end

      result

      #restaurant_from_evaluation.each do |r|
      #  if Geocoder::Calculations.distance_between([self.latitude, self.longitude], [r.latitude, r.longitude]) < distance.to_f
      #    near_restaurant_from_evaluation << r
      #    near_restaurant_id_from_evaluation << r.id
      #  end
      #end
    
      #result = []
    
      #evaluation.each do |e|
      #  next unless near_restaurant_id_from_evaluation.include? e.restaurant_id

      #  r = near_restaurant_from_evaluation.find {|restaura| restaura.id == e.restaurant_id}
      #  d = evaluation_dish.find { |dish| dish.id == e.dish_id }
      #  u = self.class.find(e.user_id)
      #  result << [e, r, d, u]
      #end

      #good_restaurant = []
      #near_restaurant_from_evaluation.each do |r|
      #  if r.actual_rating >= 3.5
      #    good_restaurant << r
      #  end
      #end

      #return [result, good_restaurant]
    #else
      #result = []
      #evaluation.each do |e|
      #  r = restaurant_class.find(e.restaurant_id)
      #  d = evaluation_dish.find { |dish| dish.id == e.dish_id }
      #  u = self.class.find(e.user_id)
      #  result << [e, r, d, u]
      #end
      #return result
    end
  end

  def top_restaurant user
    user.rating_restaurant
  end

  def following? other_user
    relationships.find_by(followed_id: other_user.id)
  end

  def follow! other_user
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow! other_user
    relationships.find_by(followed_id: other_user.id).destroy!
  end

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
