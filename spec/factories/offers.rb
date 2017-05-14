FactoryGirl.define do
  factory :offer do
    title { Faker::Beer.unique.name }
    description { Faker::Beer.unique.style }
    customer { create(:customer) }
  end
end
