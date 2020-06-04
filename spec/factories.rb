FactoryBot.define do
  factory :blocked_date do
    date "2020-05-24 18:18:44"
  end
  factory :global_order do
    source "MyString"
  end
  factory :user do
    email { Faker::Internet.email }
    password "mypassword"
    first_name "john"
    last_name "lennon"
    cpf "11687019703"
  end

  factory :random_user, class: User do
    email { Faker::Internet.email }
    password "mypassword"
    first_name { Faker::Book }
    last_name { Faker::Book }
    cpf "11687019703"
  end

  factory :product do
    name { Faker::Food }
    short_description { Faker::Job }
    description { Faker::Quotes::Shakespeare }
    price_cents 12000
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/test.jpg'), 'image/jpeg') }
  end
end
