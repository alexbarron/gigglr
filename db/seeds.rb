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
  if venue = Venue.find_by(ticketmaster_id: venue_id)
    return venue
  else
    base_url = "https://app.ticketmaster.com/discovery/v2/"
    venue_response = HTTParty.get(base_url + "venues/" + venue_id + ".json?apikey=" + Rails.application.secrets.ticketmaster_key, verify: false)
    if venue_response["country"]["countryCode"] === "US"
      venue_params = {
        name: venue_response["name"],
        ticketmaster_id: venue_response["id"],
        street_address: venue_response["address"]["line1"],
        city: venue_response["city"]["name"],
        state: venue_response["state"]["stateCode"],
        zip: venue_response["postalCode"],
        latitude: venue_response["location"]["latitude"].to_f,
        longitude: venue_response["location"]["longitude"].to_f
      }
      return Venue.create(venue_params)
    else
      return nil
    end
  end
end

def make_shows(comedian)
  base_url = "https://app.ticketmaster.com/discovery/v2/"
  shows = HTTParty.get(base_url + "events.json?apikey=" + Rails.application.secrets.ticketmaster_key + "&keyword=" + comedian.name, :verify => false)
  shows["_embedded"]["events"].each do |show|
    if venue = make_venue(show["_embedded"]["venues"].first["id"])
      name = show["name"]
      showtime = show["dates"]["start"]["localDate"] + " " + show["dates"]["start"]["localTime"]
      ticketmaster_id = show["id"]
      Show.create(name: name, showtime: showtime, venue_id: venue.id, ticketmaster_id: ticketmaster_id)
    end
  end
end

make_shows(Comedian.first)

comedians.each do |comedian|
  #make_comedian(comedian)
end
