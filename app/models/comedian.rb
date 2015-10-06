class Comedian < ActiveRecord::Base
	has_many :booked_shows, class_name: "Booking", foreign_key: "comedian_id", dependent: :destroy
	has_many :shows, through: :booked_shows
	validates :name, presence: true
end
