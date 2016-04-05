FactoryGirl.define do
    factory :task do
        association :user
        file File.open(File.join(Rails.root, 'db/simple_test_data.csv'))
    end
end
