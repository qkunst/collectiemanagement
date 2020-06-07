# frozen_string_literal: true

class Collection::UsersController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy, :manage] # includes authentication

  def show
    @manage_controller = true

    authorize! :review_collection, @collection
    authorize! :review_collection, User

    users = @collection.users_including_parent_users
    users += @collection.users_including_child_collection_users

    @users = users.uniq
    @collections = @collection.expand_with_child_collections
  end
end
