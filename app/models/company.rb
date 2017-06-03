class Company < ApplicationRecord
  validates_presence_of :name
  has_many :customers

  after_update { customers.find_each(&:touch) }
end
