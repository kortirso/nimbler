class ParsingTaskJob < ActiveJob::Base
    include Parser
    queue_as :default

    def perform(task)
        task_parser = Parser::TaskParser.new
        task.words.each do |word|
            page = task_parser.parsing(word.name)
            if page.code.to_i == 200
                for_parse = page.parser

                #top adwords
                object = for_parse.at_css('div#Z_Ltg ol')
                if object
                    i = object.children.count
                    (1..i).each do |x|
                        temp = for_parse.at_css("div#Z_Ltg ol li:nth-of-type(#{x}) cite")
                        word.links.create(type: 'top', name: temp.text) if temp
                    end
                end

                #non adwords
                object = for_parse.at_css('div#ires ol')
                if object
                    j = object.children.count
                    (1..j).each do |x|
                        temp = for_parse.at_css("div#search div#ires ol .g:nth-of-type(#{x}) .s .kv cite")
                        word.links.create(type: 'none', name: temp.text) if temp
                    end
                end

                # save html to file
                filename = "#{Rails.root}/public/uploads/task/file/#{word.task_id}/#{word.id}.html"
                file = File.new(filename, 'w')
                file.puts for_parse
                file.close

                total_results = for_parse.at_css('div#resultStats').children[0].text
                total_links = page.links.count

                word.update(complete: true, total_results: total_results, total_links: total_links, html_result: filename)
                sleep(10)
            else
                sleep(60)
            end
        end
    end
end