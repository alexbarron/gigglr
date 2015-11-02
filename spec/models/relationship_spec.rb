require 'rails_helper'

RSpec.describe Relationship, :type => :model do
  it 'has a valid factory' do
  	expect(build(:relationship)).to be_valid
  end

  it 'is invalid without a user_id' do
  	relationship = build(:relationship, user_id: nil)
  	relationship.valid?
  	expect(relationship.errors[:user_id]).to include("can't be blank")
  end

  it 'is invalid without a comedian_id' do
  	relationship = build(:relationship, comedian_id: nil)
  	relationship.valid?
  	expect(relationship.errors[:comedian_id]).to include("can't be blank")
  end
end

