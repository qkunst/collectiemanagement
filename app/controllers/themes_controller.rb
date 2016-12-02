class ThemesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_theme, only: [:show, :edit, :update, :destroy]
  before_action :set_collection

  # GET /themes
  # GET /themes.json
  def index
    @themes = Theme.all
    if @collection
      render 'collections/themes.html.erb'
    else
      @collections = Collection.without_parent.all
      render 'index.html.erb'
    end
  end

  # GET /themes/1
  # GET /themes/1.json
  def show
  end

  # GET /themes/new
  def new
    @theme = Theme.new
  end

  # GET /themes/1/edit
  def edit
  end

  # POST /themes
  # POST /themes.json
  def create
    @theme = Theme.new(theme_params)
    @theme.collection = @collection if @collection
    url = @collection ? collection_themes_url(@collection) : themes_url
    respond_to do |format|
      if @theme.save
        format.html { redirect_to url, notice: 'Thema is aangemaakt.' }
        format.json { render :show, status: :created, location: @theme }
      else
        format.html { render :new }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /themes/1
  # PATCH/PUT /themes/1.json
  def update
    respond_to do |format|
      if @theme.update(theme_params)
        url = @collection ? collection_themes_url(@collection) : themes_url

        format.html { redirect_to url, notice: 'Thema is bijgewerkt.' }
        format.json { render :show, status: :ok, location: @theme }
      else
        format.html { render :edit }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /themes/1
  # DELETE /themes/1.json
  def destroy
    @theme.destroy
    respond_to do |format|
      format.html { redirect_to themes_url, notice: 'Theme was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_theme
      @theme = Theme.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def theme_params
      params.require(:theme).permit(:name, :order, :hide, :collection_id)
    end
end
