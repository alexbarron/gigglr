# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :venue do
    name "Alejandro's Comedy Shop"
    address

    factory :invalid_venue do
    	name nil
    end
  end
end
