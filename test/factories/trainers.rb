FactoryBot.define do
  factory :trainer, class: Trainer do
    first_name { "Adi" }
    last_name { "The Trainer" }
    expertise { Trainer::EXPERTISE.first }
  end
end
