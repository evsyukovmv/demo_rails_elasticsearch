class Offer < ApplicationRecord
  validates :title, :customer, presence: true
  belongs_to :customer
end
