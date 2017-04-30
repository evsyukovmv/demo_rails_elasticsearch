class Company < ApplicationRecord
  validates_presence_of :name
  has_many :customers
end
