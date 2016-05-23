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

	def self.add_ticketmaster_venue(id)
	  if @venue = Venue.find_by(ticketmaster_id: id)
	    return @venue
	  else
	    base_url = "https://app.ticketmaster.com/discovery/v2/"
	    venue_response = HTTParty.get(base_url + "venues/" + id + ".json?apikey=" + ENV["TICKETMASTER_KEY"], verify: false)
	    if venue_response["country"]["countryCode"] === "US"
	      venue_params = {
	        name: venue_response["name"],
	        ticketmaster_id: venue_response["id"],
	        street_address: venue_response["address"]["line1"],
	        city: venue_response["city"]["name"],
	        state: venue_response["state"]["stateCode"],
	        zip: venue_response["postalCode"]
	      }
	      @venue = Venue.create(venue_params)
	      return @venue
	    else
	      return nil
	    end
	  end
	end
end