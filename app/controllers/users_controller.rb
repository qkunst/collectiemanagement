class UsersController < ApplicationController
  before_action :authenticate_admin_or_advisor_user!
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @advisors = current_user.accessible_users.advisor.order(:email).all
    @admin_users = current_user.accessible_users.admin.order(:email).all
    @appraisal_users = current_user.accessible_users.appraiser.order(:email).all
    @qkunst_users = current_user.accessible_users.qkunst.order(:email).all
    other_users = current_user.accessible_users.other.order(:email)
    @external_users = other_users.has_collections.to_a
    @unregistered_users = other_users.all - @external_users
  end

  def edit
  end

  def update
    user_params = params.require(:user).permit(:role, :receive_mails, :name, collection_ids: [])
    user_params["collection_ids"] = user_params["collection_ids"] - ["0"] if user_params["collection_ids"].include? "0"
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'De gebruiker is bijgewerkt.' }
        format.json { render :index, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'De gebruiker is verwijderd.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = current_user.accessible_users.find_by_id(params[:id])
  end
end
