class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable, :confirmable, :async

  include DeviseTokenAuth::Concerns::User
  include Geocoder::Calculations
  include OverrideDeviseRecoverable
  include ValidatesCoordinate

  validates_presence_of :email, :password, :first_name, :last_name, on: :create

  #validates_length_of [:first_name, :last_name], in: 2..30
  #validates_length_of :email, in: 6..72
  validates_length_of :password, minimum: 7, allow_blank: true
  validates_length_of :number_phone, is: 12, on: :update, allow_blank: true
  validates :latitude, numericality: { only_float: true }, on: :update, allow_blank: true
  validates :longitude, numericality: { only_float: true }, on: :update, allow_blank: true 

  has_many :evaluation

#  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

#  has_many :followed_users, through: :relationships, source: :followed
#  has_many :followers, through: :reverse_relationships, source: :follower

#  has_many :reverse_relationships, foreign_key: "followed_id",
#                                   class_name:  "Relationship",
#                                   dependent:   :destroy

  has_many :reports

  mount_base64_uploader :avatar, AvatarUploader

  def my_evaluations
    result = []

    evaluations = self.evaluation.order('updated_at DESC').includes(:dish, :restaurant)
    
    evaluations.each do |evaluation|
      e = evaluation
      d = evaluation.dish 
      r = evaluation.restaurant
      
      result << [e, r, d]
    end

    result
  end

  def feed distance, time, coordinate

    all_evaluations = 0
    result = []

    near_restaurant = Restaurant.near(coordinate, distance)

    near_restaurant.each do |restaurant|
      break if all_evaluations > 20
      next if restaurant.dishes.count == 0
       
      evaluations = Evaluation.where("updated_at >= :time and restaurant_id = :id", time: time, id: restaurant.id).order("RANDOM()").includes(:dish, :user).limit(10)
      all_evaluations += evaluations.count
      result += evaluations.map { |evaluation| [evaluation, restaurant, evaluation.dish, evaluation.user] }
    end

    return result 
  end

#  def following? other_user
#    relationships.find_by(followed_id: other_user.id)
#  end

#  def follow! other_user
#    relationships.create!(followed_id: other_user.id)
#  end

#  def unfollow! other_user
#    relationships.find_by(followed_id: other_user.id).destroy!
#  end
end
