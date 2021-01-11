FactoryBot.define do
  factory :workout do
    sequence(:name) { |n| "Workout#{n}" }
    creator { "creator" }
    duration { 0 }
    state { Workout::STATES[:published] }
    trainer { nil }
    trainee { nil }
    exercises do
      Array.new() { a.association(:exercise) }
    end
  end
end
