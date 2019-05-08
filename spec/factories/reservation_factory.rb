FactoryBot.define do
  factory :reservation do
    association :user, factory: :user
    association :book, factory: [:book, :reserved]

    trait :approved do
      after(:create) do |reservation|
        reservation.update_attributes(approved_at: 1.day.ago)
      end
    end
  end
end
