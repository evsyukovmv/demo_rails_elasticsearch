FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    address { "#{Faker::Address.country}, #{Faker::Address.city}, #{Faker::Address.street_address}" }
  end
end