FactoryGirl.define do
    factory :task do
        association :user
        file File.open(File.join(Rails.root, 'db/test_data.csv'))
    end
end
