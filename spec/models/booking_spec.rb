require 'rails_helper'

RSpec.describe Booking, :type => :model do
  it "has a valid factory" do
  	expect(build(:booking)).to be_valid
  end

  it "is invalid without a show_id" do
  	booking = build(:booking, show_id: nil)
  	booking.valid?
  	expect(booking.errors[:show_id]).to include("can't be blank")
  end

  it "is invalid without a comedian_id" do
  	booking = build(:booking, comedian_id: nil)
  	booking.valid?
  	expect(booking.errors[:comedian_id]).to include("can't be blank")
  end
end
