class Api::V1::ProfilesController < Api::V1::BaseController
    def me
        respond_with user: current_resource_owner
    end
end