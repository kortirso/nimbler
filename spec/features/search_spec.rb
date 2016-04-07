require_relative 'feature_helper'
require_relative 'sphinx_helper'

RSpec.feature 'Search text', type: :feature do
    let!(:user) { create :user }
    let!(:task) { create :task, user: user }
    let!(:word) { create :word, task: task, name: 'world of tanks' }
    let!(:link_1) { create :link, word: word }
    let!(:link_2) { create :link, word: word, type: 'none', name: 'worldoftanks.ru'}
    let!(:other_word) { create :word, task: task, name: 'porsche' }
    let!(:other_link) { create :link, word: other_word, name: 'porsche.com' }
    before do
        index
        visit root_path
    end

    describe 'show page with search results for query' do
        before do
            click_on 'Search'
            within '#search_form' do
                fill_in 'search_query', with: 'worldoftanks'
            end
        end

        it 'for all urls', js: true do
            choose('URLs with current word')
            click_on 'Start search'

            within '#search_results' do
                expect(page).to have_content "You try to find - worldoftanks"
                expect(page).to have_content "You choose option - #1"
                expect(page).to have_content 'System find 2 objects'
                expect(page).to have_content "Link url - #{link_1.name}"
                expect(page).to have_content "Link url - #{link_2.name}"
                expect(page).to_not have_content "Link url - #{other_link.name}"
            end
        end

        it 'for AdWords URLs with current word', js: true do
            choose('AdWords URLs with current word')
            click_on 'Start search'

            within '#search_results' do
                expect(page).to have_content "You try to find - worldoftanks"
                expect(page).to have_content "You choose option - #2"
                expect(page).to have_content 'System find 1 objects'
                expect(page).to have_content "Link url - #{link_1.name}"
                expect(page).to_not have_content "Link url - #{link_2.name}"
                expect(page).to_not have_content "Link url - #{other_link.name}"
            end
        end

        it 'for empty objects', js: true do
            click_on 'Start search'

            within '#search_results' do
                expect(page).to have_content "You try to find - worldoftanks"
                expect(page).to have_content "You choose option - #"
                expect(page).to have_content 'System find 2 objects'
                expect(page).to have_content "Link url - #{link_1.name}"
                expect(page).to have_content "Link url - #{link_2.name}"
                expect(page).to_not have_content "Link url - #{other_link.name}"
            end
        end
    end

    describe 'for empty query' do
        before { click_on 'Search' }

        it 'show page with no search results', js: true do
            click_on 'Start search'

            expect(page).to have_content 'System does not find anything'
        end
    end
end