class Venue < ActiveRecord::Base
	has_one :address, dependent: :destroy
	accepts_nested_attributes_for :address, allow_destroy: true
	validates_associated :address
	validates :name, presence: true
end
