module Admin
  class OAuthGroupMappingsController < ApplicationController
    def index
      authorize! :read, OAuthGroupMapping

      @o_auth_group_mappings = OAuthGroupMapping.all
    end
  end
end
