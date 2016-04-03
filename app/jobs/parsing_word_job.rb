class ParsingWordJob < ActiveJob::Base
    queue_as :default

    def perform(word)
        agent = Mechanize.new
        page = agent.get("http://www.google.com/search?q=#{word.name}")
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
