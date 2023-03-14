FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    body { "MyText" }
    user { User.first }
  end
end
