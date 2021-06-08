# frozen_string_literal: true

class Collection::UsersController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :index, :update, :destroy, :manage] # includes authentication
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @manage_controller = true

    authorize! :review_collection_users, @collection

    users = @collection.users_including_parent_users
    users += @collection.users_including_child_collection_users

    @users = users.uniq
    @collections = @collection.expand_with_child_collections
    @inactive_users = User.inactive.confirmed.to_a
  end

  def edit
    authorize! :update, @user
    @manageable_collections = Collection.where(id: manageable_collection_ids)
  end

  def update
    authorize! :update, @user

    if @user.update(user_params.merge(updated_at: Time.now))
      redirect_to collection_users_path(@collection), notice: "De gebruiker is bijgewerkt."
    else
      render :edit
    end
  end

  def set_user
    @user = User.find(params[:id])
    authorize! :read, @user
  end

  def user_params
    parameters = params.require(:user).permit(:role, collection_ids: [])

    unaffected_collection_ids = @user ? (@user.collection_ids - current_user.accessible_collection_ids) : []
    selected_manageable_collection_ids = manageable_collection_ids & parameters[:collection_ids].map(&:to_i)

    parameters[:collection_ids] = unaffected_collection_ids + selected_manageable_collection_ids

    parameters.delete "role" unless current_user.accessible_roles.include?(parameters["role"]&.to_sym)
    parameters
  end

  def manageable_collection_ids
    @manageable_collection_ids ||= @collection.expand_with_child_collections.pluck(:id) & current_user.accessible_collection_ids
  end
end
