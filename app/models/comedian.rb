class Comedian < ActiveRecord::Base
	validates :name, presence: true
end
