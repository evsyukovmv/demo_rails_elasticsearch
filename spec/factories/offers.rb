FactoryGirl.define do
  factory :offer do
    title { Faker::Book.unique.title }
    description { "#{Faker::Book.author}, #{Faker::Book.publisher}, #{Faker::Book.genre}" }
    customer { create(:customer) }
  end
end
