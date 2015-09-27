require 'rails_helper'

RSpec.describe Comedian do
  it "has a valid factory" do
  	expect(build(:comedian)).to be_valid
  end

  it "is invalid without a name" do
  	comedian = build(:comedian, name: nil)
  	comedian.valid?
  	expect(comedian.errors[:name]).to include("can't be blank")
  end

end
