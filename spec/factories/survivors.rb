FactoryBot.define do
  factory :survivor do
    name { 'Survivor 1' }
    age { 43 }
    infection_count { 0 }
    gender { 'male' }
    last_location { {latitude: '89809809809', longitude: '-88983982100'} }

    factory :survivor_1 do
      name { 'Rick' }
    end

    factory :survivor_2 do
      name { 'Negan' }
      age { 51 }
      gender { 'male' }
      last_location { {latitude: '-82178299809', longitude: '-12375638001'} }
      infection_count { 1 }
    end

    trait :with_resources do
      resources_attributes { [FactoryBot.attributes_for(:resource, :food, quantity: 23)] }
    end

    trait :infected do
      infection_count { 3 }
    end

    trait :not_infected do
      infection_count { 0 }
    end

    trait :almost_infected do
      infection_count { 2 }
    end
  end
end