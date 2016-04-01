FactoryGirl.define do
    factory :word do
        association :task
        name 'something'
        total_links 0
        total_results 0
        html_result ''
    end
end
