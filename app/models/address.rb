class Address < ActiveRecord::Base
	belongs_to :venue
	validates_presence_of :street_address
	validates_presence_of :city
	validates_presence_of :state
	validates_presence_of :zip

	def full_address
		"#{street_address}, #{city}, #{state}, #{zip}"
	end

	def city_state
		"#{city}, #{state}"
	end

end
