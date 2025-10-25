FactoryBot.define do
  factory :movie do
    user
    title { "JOAO" }
    synopsis { "Lorem ipsum dolor sit amet, consectetur adipiscing elit." }
    release_year { 2001 }
    duration { 120 }
    director { "Jane Doe" }
    categories { [ association(:category) ] }
  end
end
