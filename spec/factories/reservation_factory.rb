FactoryBot.define do
  factory :reservation do
    association :user, factory: :user
    association :book, factory: [:book, :reserved]
  end
end
