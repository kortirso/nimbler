class ParsingTaskJob < ActiveJob::Base
    include Parser
    queue_as :default

    def perform(task)
        parser = Parser::TaskParser.new
        task.words.each do |word|
            page = parser.parsing(word.name)
            if page.code.to_i == 200
                parser = page.parser

                #top adwords
                i = parser.at_css('div#Z_Ltg ol').children.count
                (1..i).each do |x|
                    link_text = parser.at_css("div#Z_Ltg ol li:nth-of-type(#{x}) cite").text
                    word.links.create(type: 'top', name: link_text)
                end

                #non adwords
                j = parser.at_css('div#ires ol').children.count
                (1..j).each do |x|
                    object = parser.at_css("div#search div#ires ol .g:nth-of-type(#{x}) .s .kv cite")
                    word.links.create(type: 'none', name: object.text) unless object.nil?
                end

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