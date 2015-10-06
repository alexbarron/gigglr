class Booking < ActiveRecord::Base
	belongs_to :comedian
	belongs_to :show
	validates_presence_of :comedian_id
	validates_presence_of :show_id
end
