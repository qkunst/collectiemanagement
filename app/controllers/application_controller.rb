class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_activated_user!, except: [:heartbeat, :home]
  # before_action :authenticate_qkunst_user!, except: [:heartbeat, :home]
  before_action :offline?
  before_action :show_hidden

  def home

  end

  def geoname_summaries
    render json: GeonameSummary.selectable.to_array.to_json
  end

  def offline?
    @offline = params[:offline]
  end

  def debug_offline
    @offline = true
  end

  def admin

  end

  def heartbeat
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    render text: 'alive', layout: false
  end

  def admin_user?
    current_user && current_user.admin?
  end

  private

  def show_hidden
    @show_hidden = false
    if params[:show_hidden] && (params[:show_hidden] == "true" or params[:show_hidden] == true)
      @show_hidden = true
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_collection
    authenticate_activated_user!
    if params[:collection_id]
      @collection = Collection.find(params[:collection_id])
      unless current_user.admin?
        redirect_options = offline? ? {} : {alert: "U heeft geen toegang tot deze collectie"}
        redirect_to root_path, redirect_options unless @collection.can_be_accessed_by_user(current_user)
      end
    end
  end

  def set_work
    authenticate_activated_user!
    if params[:work_id]
      @work = Work.find(params[:work_id])
    end
  end

  def authenticate_qkunst_user!
    unless devise_controller?
      authenticate_user!
      if current_user
        redirect_options = offline? ? {} : {alert: "Alleen medewerkers van QKunst kunnen deze pagina bekijken"}
        redirect_to root_path, redirect_options unless current_user.qkunst?
      end
    end
  end

  def authenticate_qkunst_user_if_no_collection!
    set_collection
    unless current_user.qkunst?
      redirect_options = offline? ? {} : {alert: "U dient een QKunst medewerker te zijn"}
      redirect_to root_path, redirect_options
    end
  end

  def authenticate_qkunst_or_facility_user!
    authenticate_user!
    if current_user
      redirect_options = offline? ? {} : {alert: "U heeft geen toegang tot deze pagina"}
      redirect_to root_path, redirect_options unless (current_user.qkunst? or current_user.facility_manager?)
    end
  end

  def authenticate_admin_or_facility_user!
    authenticate_user!
    if current_user
      redirect_options = offline? ? {} : {alert: "U heeft geen toegang tot deze pagina"}
      redirect_to root_path, redirect_options unless (current_user.admin? or current_user.facility_manager?)
    end
  end

  def authenticate_activated_user!
    unless devise_controller?
      authenticate_user!
      if current_user
        redirect_options = offline? ? {} : {alert: "Alleen geactiveerde gebruikers kunnen deze pagina bekijken. Nog niet geactiveerd? Neem contact op met QKunst."}
        redirect_to root_path, redirect_options unless current_user.activated?
      end
    end
  end

  def authenticate_admin_user!
    authenticate_user!
    if current_user
      redirect_options = offline? ? {} : {alert: "Alleen administratoren van QKunst kunnen deze pagina bekijken"}
      redirect_to root_path, redirect_options unless current_user.admin?
    end
  end



end
