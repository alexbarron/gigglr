# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	email { Faker::Internet.email }
  	password 'super_secure_password'
  	password_confirmation 'super_secure_password'

  	factory :admin do
  		admin true
  	end
  end
end
