FactoryGirl.define do
    factory :link do
        association :word
        name 'worldoftanks.com'
        type 'top'
    end
end
