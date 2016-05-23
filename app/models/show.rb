class Show < ActiveRecord::Base
	has_many :booked_comedians, class_name: "Booking", foreign_key: "show_id", dependent: :destroy
	has_many :comedians, through: :booked_comedians
	belongs_to :venue
	validates_presence_of :name
	validates_presence_of :venue_id
	validates_presence_of :showtime

  def short_date
    self.showtime.strftime('%-m/%-d')
  end

  def short_datetime
    self.showtime.strftime('%l:%M %p %b %-d')
  end

  def long_datetime
    self.showtime.strftime('%l:%M %p %b %e, %Y')
  end
  
	def book_comedian(comedian)
		booked_comedians.create(comedian_id: comedian.id) unless self.comedians.where(id: comedian.id).any?
	end

	def unbook_comedian(comedian)
		booked_comedians.find_by(comedian_id: comedian.id).destroy
	end

	def booked_comedian?(comedian)
		comedians.include?(comedian)
	end

	def notify_fans_of(comedian, show)
		fans = Relationship.where("comedian_id = ?", comedian.id)
		local_fans = []
		fans.each do |fan|
			if fan.user.distance_to(show.venue) < fan.user.distance_pref
				local_fans.push(fan.user)
			end
		end
		local_fans.each do |local_fan|
			UserMailer.new_show(local_fan, comedian, show).deliver_now
		end
	end

  def self.nearby(location, distance_pref)
    venues = Venue.near(location, distance_pref)
    venue_ids = venues.map(&:id)
    Show.where('showtime > ? AND venue_id IN (?)', Time.now, venue_ids).includes(:comedians, :venue).order("showtime ASC").limit(20)
  end

	def self.add_ticketmaster_show(show, comedian)
    if existing_show = Show.find_by(ticketmaster_id: show["id"])
      existing_show.book_comedian(comedian)
    else
      if !show["name"].downcase.include?("parking") && venue = Venue.add_ticketmaster_venue(show["_embedded"]["venues"].first["id"])
        name = show["name"]
        showtime = show["dates"]["start"]["localDate"] + " " + show["dates"]["start"]["localTime"]
        ticketmaster_id = show["id"]
        show = Show.create(name: name, showtime: showtime, venue_id: venue.id, ticketmaster_id: ticketmaster_id)
        show.book_comedian(comedian)
      end
    end
	end

	def self.bulk_ticketmaster_adder(comedian)
	  base_url = "https://app.ticketmaster.com/discovery/v2/"
	  events_response = HTTParty.get(base_url + "events.json?apikey=" + ENV["TICKETMASTER_KEY"] + "&attractionId=" + comedian.ticketmaster_id, :verify => false)
	  if !!events_response && !!events_response["_embedded"]
	    events_response["_embedded"]["events"].each do |show|
	    	Show.add_ticketmaster_show(show, comedian)
	    end
	  end
	end
end