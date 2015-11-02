class Comedian < ActiveRecord::Base
	has_many :booked_shows, class_name: "Booking", foreign_key: "comedian_id", dependent: :destroy
	has_many :shows, through: :booked_shows
	has_many :passive_relationships, class_name: "Relationship", foreign_key: "comedian_id", dependent: :destroy
	has_many :users, through: :passive_relationships
	validates :name, presence: true
end
