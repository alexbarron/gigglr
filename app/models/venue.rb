class Venue < ActiveRecord::Base
	has_many :shows
	validates :name, presence: true
	validates :street_address, presence: true
	validates :city, presence: true
	validates :state, presence: true
	validates :zip, presence: true
	geocoded_by :full_address
	after_validation :geocode, if: :full_address_changed?

	def full_address
		"#{street_address}, #{city}, #{state}, #{zip}"
	end

	def city_state
		"#{city}, #{state}"
	end

	def full_address_changed?
		if street_address_changed? || city_changed? || state_changed? || zip_changed?
			return true
		end
	end
end

