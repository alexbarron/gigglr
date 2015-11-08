# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :venue do
    name "Alejandro's Comedy Shop"
    street_address "5900 Wilshire Blvd"
    city "Los Angeles"
    state "CA"
    zip "90036"


    factory :invalid_venue do
    	name nil
    end
    
  end
end
