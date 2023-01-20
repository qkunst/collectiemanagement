module Admin
  class AdminController < ApplicationController
    def index
      authorize! :read, AdminController
    end
  end
end
