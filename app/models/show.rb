class Show < ActiveRecord::Base
	belongs_to :venue
	validates_presence_of :name
	validates_presence_of :venue_id
	validates_presence_of :showtime
end
