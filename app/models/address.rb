class Address < ActiveRecord::Base
	belongs_to :venue

	def full_address
		"#{street_address}, #{city}, #{state}, #{zip}"
	end

	def city_state
		"#{city}, #{state}"
	end

end
