class Venue < ActiveRecord::Base
	has_one :address, dependent: :destroy
	accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank
	validates :name, presence: true
end
