require 'mechanize'
require 'open-uri'
require 'socksify/http'

class ParsingTaskJob < ActiveJob::Base
    queue_as :default

    def perform(task)
        agent = Mechanize.new
        Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start('bot.whatismyipaddress.com', 80) do |http|
            task.words.each do |word|
                page = agent.get("http://www.google.com/search?hl=en&q=#{word.name}")
                if page.code.to_i == 200
                    parser = page.parser

                    # save html to file
                    filename = "#{Rails.root}/public/uploads/task/file/#{word.task_id}/#{word.id}.html"
                    file = File.new(filename, 'w')
                    file.puts parser
                    file.close

                    total_results = parser.at_css('div#resultStats').children[0].text
                    total_links = page.links.count

                    word.update(complete: true, total_results: total_results, total_links: total_links, html_result: filename)
                    sleep(10)
                else
                    sleep(30)
                end
            end
        end
    end
end