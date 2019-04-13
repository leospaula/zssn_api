FactoryBot.define do
  factory :survivor do
    name { 'Survivor 1' }
    age { 43 }
    infection_count { 0 }
    gender { 'male' }
    last_location { {latitude: '89809809809', longitude: '-88983982100'} }
  end
end