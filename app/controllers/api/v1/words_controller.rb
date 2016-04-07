class Api::V1::WordsController < Api::V1::BaseController
    def show
        @word = Word.find(params[:id])
        if @word.task.user_id == current_resource_owner.id
            respond_with @word, serializer: WordSerializer::WithLinks
        else
            render text: 'no access'
        end
    end
end