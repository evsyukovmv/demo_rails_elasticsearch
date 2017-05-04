# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

puts '=' * 10, 'seeds started', '=' * 10

companies = FactoryGirl.create_list(:company, 10)

companies.each do |company|
  FactoryGirl.create_list(:customer, rand(10) + 10, company: company)
end

Customer.all.each do |customer|
  FactoryGirl.create_list(:offer, rand(10) + 20, customer: customer)
end

puts '=' * 10, 'seeds finished', '=' * 10
