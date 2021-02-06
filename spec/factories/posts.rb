FactoryBot.define do
  factory :post do
    title {'hoge'}
    content {'fuga'}
    association :user
  end
end
