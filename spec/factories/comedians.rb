# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :comedian do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    
    picture { fixture_file_upload "#{Rails.root}/spec/fixtures/default.jpg", 'image/jpg' }

    factory :invalid_comedian do
    	name nil
    end
  end
end
