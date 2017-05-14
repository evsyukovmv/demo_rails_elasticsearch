FactoryGirl.define do
  factory :customer do
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    company { create(:company) }
  end
end