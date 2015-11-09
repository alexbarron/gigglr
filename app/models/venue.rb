class Venue < ActiveRecord::Base
	has_many :shows
	validates :name, presence: true
	validates :street_address, presence: true
	validates :city, presence: true
	validates :state, presence: true
	validates :zip, presence: true
	geocoded_by :full_address
	after_validation :geocode

	def full_address
		"#{street_address}, #{city}, #{state}, #{zip}"
	end

	def city_state
		"#{city}, #{state}"
	end
end

