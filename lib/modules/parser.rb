require 'mechanize'
require 'socksify/http'

module Parser
    class TaskParser
        def initialize
            @agent = Mechanize.new
            @agent.user_agent_alias = 'Windows IE 6'
        end

        def parsing(word)
            uri = URI.parse("http://www.google.com/search?hl=en&q=#{word}")
            page = nil
            Net::HTTP.SOCKSProxy('127.0.0.1', 9050).start(uri.host, uri.port) { |http| page = @agent.get(uri) }
            @agent.history.clear
            page
        end
    end
end