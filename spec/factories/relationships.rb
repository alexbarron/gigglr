# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :relationship do
  	user
  	comedian

  	factory :invalid_relationship do
  		user_id nil
  	end
  end
end
