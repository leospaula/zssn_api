FactoryBot.define do
  factory :survivor do
    name { 'Survivor 1' }
    age { 43 }
    infection_count { 0 }
    gender { 'male' }
    last_location { {latitude: '89809809809', longitude: '-88983982100'} }

    trait :with_resources do
      resources_attributes { [FactoryBot.attributes_for(:resource, :food, quantity: 23)] }
    end
  end
end