require 'rails_helper'

RSpec.describe Address, :type => :model do
  it "is invalid without a street address" do
  	address = build(:address, street_address: nil)
  	address.valid?
  	expect(address.errors[:street_address]).to include("can't be blank")
  end
   it "is invalid without a city" do
  	address = build(:address, city: nil)
  	address.valid?
  	expect(address.errors[:city]).to include("can't be blank")
  end
   it "is invalid without a state" do
  	address = build(:address, state: nil)
  	address.valid?
  	expect(address.errors[:state]).to include("can't be blank")
  end
   it "is invalid without a zip" do
  	address = build(:address, zip: nil)
  	address.valid?
  	expect(address.errors[:zip]).to include("can't be blank")
  end
end
