# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  authorize_resource except: [:oauth]

  def index
    authorize! :update, @user
    @advisors = current_user.accessible_users.advisor.order(:email).all
    @admin_users = current_user.accessible_users.admin.order(:email).all
    @appraisal_users = current_user.accessible_users.appraiser.order(:email).all
    @registrator_users = current_user.accessible_users.registrator.order(:email).all
    other_users = current_user.accessible_users.other.confirmed.order(:email)
    @external_users = other_users.has_collections.to_a
    @unregistered_users = other_users.recently_updated.all - @external_users
  end

  def edit
    authorize! :update, @user
  end

  def oauth
    @methods = if params[:methods] == "google"
      [:google]
    elsif params[:methods] == "microsoft"
      [:microsoft]
    else
      [:google, :microsoft]
    end
  end

  def update
    authorize! :update, @user

    if @user.update(user_params)
      redirect_to users_path, notice: "De gebruiker is bijgewerkt."
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @user

    @user.destroy
    redirect_to users_path, notice: "De gebruiker is verwijderd."
  end

  private

  def user_params
    authenticate_admin_user!
    parameters = params.require(:user).permit(:role, :role_manager, :receive_mails, :name, collection_ids: [])
    current_untouchable_collections = @user.collections.map(&:id) - current_user.accessible_collections.map(&:id)
    parameters["collection_ids"] = (parameters["collection_ids"].map(&:to_i) & current_user.accessible_collections.map(&:id)) + current_untouchable_collections
    parameters
  end

  def set_user
    @user = current_user.accessible_users.find_by_id(params[:id])
  end
end
