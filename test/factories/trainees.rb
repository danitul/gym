FactoryBot.define do
  factory :trainee do
    first_name { "Alex" }
    last_name { "Trainee" }
    sequence(:email) { |n| "#{first_name}.#{last_name}.#{n}@gym.com" }
  end
end
