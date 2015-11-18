class Show < ActiveRecord::Base
	has_many :booked_comedians, class_name: "Booking", foreign_key: "show_id", dependent: :destroy
	has_many :comedians, through: :booked_comedians
	belongs_to :venue
	validates_presence_of :name
	validates_presence_of :venue_id
	validates_presence_of :showtime

	def book_comedian(comedian)
		booked_comedians.create(comedian_id: comedian.id)
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
end
