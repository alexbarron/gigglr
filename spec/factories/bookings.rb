# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :booking do
  	comedian
  	show
  	
  	factory :invalid_booking do
  		show_id nil
  	end
  end
end
