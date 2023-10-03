FactoryBot.define do
  factory :booking do
    association :user
    association :football_pitch
    booking_price { Faker::Number.between(from: 10, to: 99) * 10000 }
    start_at { Faker::Time.between(from: 4.months.ago, to: Time.current) }
    end_at { start_at + 1.hour }
    note { "Hàng dễ vỡ xin nhẹ tay" }
    booking_status { Faker::Number.between(from: 0, to: 5) }
  end
end
