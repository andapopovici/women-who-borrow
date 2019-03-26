FactoryBot.define do
  factory :book do
    title { "Pragmatic Programmer" }
    author { "Andy Hunt" }
    edition { "1" }
    year { 1999 }
    isbn { "9780201616224" }
    association :user, factory: :user
    status { Book::AVAILABLE }

    trait :reserved do
      status { Book::RESERVED }
      after(:create) do |book|
        create(:reservation, book: book)
      end
    end

    trait :borrowed do
      status { Book::BORROWED }
      after(:create) do |book|
        create(:reservation, book: book)
      end
    end
  end
end
