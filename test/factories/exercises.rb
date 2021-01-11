FactoryBot.define do
  factory :exercise do
    sequence(:name) { |n| "Exercise#{n}" }
    duration { 1 }
  end
end
