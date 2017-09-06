class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User
  has_and_belongs_to_many :evaluation

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy

  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy

  has_many :rating_restaurant

  def news
    evaluation = Evaluation.from_users_followed_by(self)
    evaluation_dish = Dish.find(evaluation.map { |e| e.dish_id })
    [evaluation, evaluation_dish]
  end

  def top_restaurant user
    user.evaluations
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
end
