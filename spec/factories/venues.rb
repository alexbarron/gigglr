# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :venue do
    name "Alejandro's Comedy Shop"
    association :address, strategy: :build


    factory :invalid_venue do
    	name nil
    end

    factory :no_address_venue do
    	address nil
    end
  end
end
