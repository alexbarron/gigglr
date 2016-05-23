class Comedian < ActiveRecord::Base
	has_many :booked_shows, class_name: "Booking", foreign_key: "comedian_id", dependent: :destroy
	has_many :shows, through: :booked_shows
	has_many :passive_relationships, class_name: "Relationship", foreign_key: "comedian_id", dependent: :destroy
	has_many :users, through: :passive_relationships
	validates :name, presence: true
	has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ":style/default.jpg"
	validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

	def self.search(search)
		if search
			where("name ILIKE ?", "%#{search}%") 
		else
			find(:all)
		end
	end

	def self.add_ticketmaster_comedian(id)
	  base_url = "https://app.ticketmaster.com/discovery/v2/"
	  comedian_response = HTTParty.get(base_url + 'attractions/' + id + '.json?apikey=' + ENV["TICKETMASTER_KEY"], verify: false)
	  if @comedian = Comedian.find_by(ticketmaster_id: comedian_response["id"])
	  	return @comedian
	  else
	  	name = comedian_response["name"]
	  	id = comedian_response["id"]
	  	image = comedian_response["images"].find {|image| image["fallback"] == false }
		  @comedian = Comedian.create(name: name, ticketmaster_id: id)
		  @comedian.picture = URI.parse(image["url"])
		  @comedian.save
	    @comedian.add_shows
		  return @comedian
		end
	end

	def self.search_ticketmaster(name)
		base_url = "https://app.ticketmaster.com/discovery/v2/"
		comedian_response = HTTParty.get(base_url + 'attractions.json?apikey=' + ENV["TICKETMASTER_KEY"] + '&keyword=' + name, verify: false)
		return comedian_response["_embedded"]["attractions"]
	end

	def self.update_comedians_shows
		self.all.each do |comedian|
			comedian.add_shows
		end
	end

	def self.all_with_shows_and_users
		self.order("fan_count DESC").includes(:users, :shows).where("shows.showtime > ?", Time.now ).order("shows.showtime ASC").references(:shows)
	end

	def add_shows
		Show.bulk_ticketmaster_adder(self)
	end

	def future_shows
		self.shows.where("showtime > ?", Time.now).order("showtime ASC").includes(:venue)
	end

end
