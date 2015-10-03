require 'rails_helper'

RSpec.describe Venue, :type => :model do
  it "has a valid factory" do
  	expect(build(:venue)).to be_valid
  end
  it "is invalid without a name" do
  	venue = build(:venue, name: nil)
  	venue.valid?
  	expect(venue.errors[:name]).to include("can't be blank")
  end
end
