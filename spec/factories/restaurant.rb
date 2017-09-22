FactoryGirl.define do 
  factory :restaurant do

    title "Restaurant" 
    description "description" * 10

    trait :good do
      number_of_ratings 60
      average_ratings 5
      sum_ratings 300
      actual_rating 4.62
    end

    trait :bad do
      number_of_ratings 60
      average_ratings 2
      sum_ratings 120
      actual_rating 2.68
    end

    trait :null_rating do
      number_of_ratings 0
      average_ratings 0
      sum_ratings 0
      actual_rating 0
    end
    
    trait :coordinate_1 do
      latitude 50.619638
      longitude 26.248218
    end

    trait :coordinate_2 do
      latitude 50.631738
      longitude 26.273297
    end

    state "Rivnenska Obl."

    trait :rivne do
      city "Rivne"
      latitude 50.619638
      longitude 26.248218
    end

    trait :ostrog do
      city "Ostrog"
      latitude 50.333972
      longitude 26.499987
    end
  end
end
