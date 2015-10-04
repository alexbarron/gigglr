require 'rails_helper'

RSpec.describe Show, :type => :model do
  it "has a valid factory" do
  	expect(build(:show)).to be_valid
  end
  it "is invalid without a name" do
  	show = build(:show, name: nil)
  	show.valid?
  	expect(show.errors[:name]).to include("can't be blank")
  end
  it "is invalid without a showtime" do
  	show = build(:show, showtime: nil)
  	show.valid?
  	expect(show.errors[:showtime]).to include("can't be blank")
  end
  it "is invalid without a venue_id" do
  	show = build(:show, venue_id: nil)
  	show.valid?
  	expect(show.errors[:venue_id]).to include("can't be blank")
  end
end
