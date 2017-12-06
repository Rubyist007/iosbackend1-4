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

  has_and_belongs_to_many :evaluation

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

    evaluations = self.evaluation.order('updated_at DESC')
    
    evaluations.each do |evaluation|
      e = evaluation
      d = Dish.find(evaluation.dish_id)
      r = Restaurant.find(evaluation.restaurant_id)
      
      result << [e, r, d]
    end

    result
  end

  def feed distance, time, coordinate
        
    if coordinate

      near_restaurant = Restaurant.near(coordinate, distance)

      evaluation = []
      dishes = []
      result = []

      near_restaurant.each do |r|
        next if r.dishes.count == 0
        offset = rand(r.dishes.count)
        dishes << r.dishes.offset(offset).first
      end

      dishes.each do |d|
          ev = d.evaluation.where("updated_at >= :time", time: time).limit(1).order("updated_at DESC")
          if ev[0]
            evaluation << ev 
          else
            next
          end
        end

      return ["Feed empty"] if evaluation.blank? 

      evaluation.each do |e|
        r = Restaurant.find(e[0].restaurant_id)
        d = dishes.find { |dish| dish.id == e[0].dish_id }
        u = self.class.find(e[0].user_id)
        result << [e[0], r, d, u]
      end

      return result 
    end
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
