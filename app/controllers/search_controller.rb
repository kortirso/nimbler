class SearchController < ApplicationController
    def find
        @objects = params[:search][:query].empty? ? nil : find_object(params[:search][:query], params[:search][:options].to_i)
    end

    private
    def find_object(query, option)
        riddle_query = Riddle::Query.escape(query)
        objects = case option
            when 1 then Link.search riddle_query
            when 2 then Link.search riddle_query, conditions: {type: "top"}
            else ThinkingSphinx.search riddle_query
        end
        objects
    end
end