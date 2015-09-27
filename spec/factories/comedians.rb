# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comedian do
    name { Faker::Name.name }
    description {Faker::Lorem.paragraph }

    factory :invalid_comedian do
    	name nil
    end
  end
end
