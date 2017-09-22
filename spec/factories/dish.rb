FactoryGirl.define do
  factory :dish do

    name 'Dihs'
    description 'description'*10

    trait :restaurant_one do
      restaurant_id 1
    end

    trait :restaurant_two do
      restaurant_id 2
    end
  end
end
