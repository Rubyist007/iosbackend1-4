FactoryGirl.define do
  factory :user do
    trait :email_0 do
      email "test0@gmail.com"
    end

    trait :email_1 do
      email "test1@gmail.com"
    end

    password "123456789test"
    latitude 50.619808
    longitude 26.249667
  end
end
