class Evaluation < ApplicationRecord
  
  validates_presence_of  :user_id ,:dish_id, :restaurant_id, :evaluation

  validates :evaluation, numericality: { less_than_or_equal: 5.00 }

  def self.from_users_followed_by user, time_ago 
    followed_user_ids = "SELECT followed_id FROM relationships 
                         WHERE follower_id = :user_id" 
    self.where("user_id IN (#{followed_user_ids}) AND updated_at >= :time", 
          user_id: user.id,time: time_ago).limit(20).order("updated_at DESC")
   
  end
end
