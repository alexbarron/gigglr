# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


comedians = [
  "Bill Burr",
  "Jerry Seinfeld",
  "Chris Rock",
  "Dave Chappelle",
  "Sarah Silverman",
  "Whitney Cummings",
  "Joe Rogan",
  "Iliza Shlesinger",
  "Marc Maron",
  "Anthony Jeselnik",
  "Ari Shaffir",
  "Chris Tucker",
  "Jim Gaffigan",
  "Dave Attell",
  "Louis C.K.",
]

def make_comedian(comedian)
  base_url = "https://app.ticketmaster.com/discovery/v2/"
  comedian_response = HTTParty.get(base_url + 'attractions.json?apikey=' + Rails.application.secrets.ticketmaster_key + '&keyword=' + comedian, verify: false)

  name = comedian_response["_embedded"]["attractions"].first["name"]
  id = comedian_response["_embedded"]["attractions"].first["id"]
  image = comedian_response["_embedded"]["attractions"].first["images"][4]["url"]

  @comedian = Comedian.create(name: name, ticketmaster_id: id)
  @comedian.picture = URI.parse(image)
  @comedian.save
end

def make_venue(venue_id)
  venue_response = HTTParty.get(base_url + "venues/" + venue_id + ".json?apikey=" + Rails.application.secrets.ticketmaster_key, verify: false)
  #httparty to get venue info
  #set address
  #find_or_create venue with address, name, and ticketmaster id
end

def make_shows(comedian)
  shows = 
  shows.each do |show|
    name = show["name"]
    showtime = show["dates"]["start"]["localDate"] + " " + show["dates"]["start"]["localTime"]
  end
end

comedians.each do |comedian|
  make_comedian(comedian)
end
