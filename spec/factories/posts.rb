FactoryBot.define do
  factory :post do
    title {'hoge'}
    content {'fuga'}
    association :user

    after(:build) do |post|
      post.image.attach(io: File.open('public/images/test.png'), filename: 'test.png')
    end

  end
end
