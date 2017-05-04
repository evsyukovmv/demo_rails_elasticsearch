class Company < ApplicationRecord
  validates_presence_of :name
  has_many :customers

  after_update { Offer.where(customer_id: customers.pluck(:id)).each(&:touch) }
end
