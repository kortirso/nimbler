require 'mechanize'
require 'open-uri'
require 'socksify/http'

class ParsingWordJob < ActiveJob::Base
    queue_as :default

    def perform(word)
        page = nil
        Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start('google.com', 80) { |http| page = Mechanize.new.get("http://www.google.com/search?hl=en&q=#{word.name}") }
        parser = page.parser

        # save html to file
        filename = "#{Rails.root}/public/uploads/task/file/#{word.task_id}/#{word.id}.html"
        file = File.new(filename, 'w')
        file.puts parser
        file.close

        total_results = parser.at_css('div#resultStats').children[0].text
        total_links = page.links.count

        word.update(html_result: filename, total_results: total_results, total_links: total_links, complete: true)
    end
end
