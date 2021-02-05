FactoryBot.define do
  factory :user do
    nickname {Faker::Name.last_name.slice(1..6)}
    email {Faker::Internet.free_email}
    password {Faker::Internet.password(min_length: 6)}
    password_confirmation {password}
  end
end
