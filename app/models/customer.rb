class Customer < ApplicationRecord
  validates :first_name, :last_name, :company, presence: true
  belongs_to :company
  has_many :offers
end
