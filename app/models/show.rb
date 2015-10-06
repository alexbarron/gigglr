class Show < ActiveRecord::Base
	has_many :booked_comedians, class_name: "Booking", foreign_key: "show_id", dependent: :destroy
	has_many :comedians, through: :booked_comedians
	belongs_to :venue
	validates_presence_of :name
	validates_presence_of :venue_id
	validates_presence_of :showtime
end
