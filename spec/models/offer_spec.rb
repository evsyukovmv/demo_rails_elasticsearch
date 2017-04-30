require 'rails_helper'

RSpec.describe Offer, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:customer) }
  it { should belong_to(:customer) }
end
