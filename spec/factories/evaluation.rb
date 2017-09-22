FactoryGirl.define do
  factory :evaluation do
    
    trait :user_one do 
      user_id 1
    end

    trait :user_two do
      user_id 2
    end

    trait :dish_one do
      dish_id 1
    end

    trait :dish_two do
      dish_id 2
    end

    trait :dish_three do
      dish_id 3
    end

    trait :restaurant_one do
      restaurant_id 1
    end

    trait :restaurant_two do
      restaurant_id 2
    end

    evaluation 4
  end
end
