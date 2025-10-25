FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "user#{n}@email.com" }
    password { "password" }
  end
end
