class Relationship < ActiveRecord::Base
	belongs_to :comedian
	belongs_to :user
	validates_presence_of :comedian_id
	validates_presence_of :user_id
end
