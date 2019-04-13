FactoryBot.define do
  factory :resource do
    trait :water do
      name { 'water' }
      quantity { 10 }
    end

    trait :food do
      name { 'food' }
      quantity { 15 }
    end   

    trait :medication do
      name { 'medication' }
      quantity { 8 }
    end   

    trait :ammunition do
      name { 'ammunition' }
      quantity { 200 }
    end   
  end
end