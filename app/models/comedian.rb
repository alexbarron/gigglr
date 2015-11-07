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
end
