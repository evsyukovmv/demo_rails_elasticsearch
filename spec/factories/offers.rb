FactoryGirl.define do
  factory :offer do
    title { Faker::Coffee.blend_name }
    description { Faker::Coffee.notes }
    customer { create(:customer) }
  end
end