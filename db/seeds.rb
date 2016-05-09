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
  "Brian Regan"
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
        zip: venue_response["postalCode"]
      }
      return Venue.create(venue_params)
    else
      return nil
    end
  end
end

def make_shows(comedian)
  base_url = "https://app.ticketmaster.com/discovery/v2/"
  show_response = HTTParty.get(base_url + "events.json?apikey=" + Rails.application.secrets.ticketmaster_key + "&attractionId=" + comedian.ticketmaster_id, :verify => false)
  if !!show_response && !!show_response["_embedded"]
    show_response["_embedded"]["events"].each do |show|
      if existing_show = Show.find_by(ticketmaster_id: show["id"])
        existing_show.book_comedian(comedian)
      else
        if !show["name"].downcase.include?("parking") && venue = make_venue(show["_embedded"]["venues"].first["id"])
          name = show["name"]
          showtime = show["dates"]["start"]["localDate"] + " " + show["dates"]["start"]["localTime"]
          ticketmaster_id = show["id"]
          show = Show.create(name: name, showtime: showtime, venue_id: venue.id, ticketmaster_id: ticketmaster_id)
          show.book_comedian(comedian)
        end
      end
    end
  end
end

Comedian.all.each do |comedian|
  #make_shows(comedian)
end

comedians.each do |comedian|
  #make_comedian(comedian)
end
