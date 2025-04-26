FactoryBot.define do
  factory :session do
    duration { 1.hour.to_i }
    played_at { Time.zone.yesterday }

    game { association :game }
  end
end
