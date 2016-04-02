require 'mechanize'
require 'open-uri'

class Word < ActiveRecord::Base
    belongs_to :task

    validates :name, :task_id, presence: true

    after_create :parse_word

    private
    def parse_word
        agent = Mechanize.new
        page = agent.get("http://www.google.com/search?q=#{self.name}")
        parser = page.parser

        # save html to file
        file = File.new("#{Rails.root}/public/uploads/task/file/#{self.task.id}/#{self.id}.html", 'w')
        file.puts parser
        file.close

        total_results = parser.at_css('div#resultStats').children[0].text
        total_links = page.links.count

        self.update(html_result: "#{Rails.root}/public/uploads/task/file/#{self.task.id}/#{self.id}.html", total_results: total_results, total_links: total_links)
    end
end
