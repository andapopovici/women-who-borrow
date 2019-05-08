FactoryBot.define do
  factory :book do
    title { "Pragmatic Programmer" }
    author { "Andy Hunt" }
    edition { "1" }
    year { 1999 }
    isbn { "9780201616224" }
    association :user, factory: :user

    trait :reserved do
      after(:create) do |book|
        create(:reservation, book: book)
      end
    end

    trait :borrowed do
      after(:create) do |book|
        create(:reservation, :approved, book: book)
      end
    end
  end
end
