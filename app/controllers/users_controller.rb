class UsersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @admin_users = User.admin.order(:email).all
    @qkunst_users = User.qkunst.order(:email).all
    other_users = User.other.order(:email)
    @external_users = other_users.has_collections.all
    @unregistered_users = other_users.all - @external_users
  end

  def edit
  end

  def update
    user_params = params.require(:user).permit(:role, :receive_mails, collection_ids: [])
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
    @user = User.find_by_id(params[:id])
  end
end
