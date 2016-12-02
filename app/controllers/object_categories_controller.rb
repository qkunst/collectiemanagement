class ObjectCategoriesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_object_category, only: [:show, :edit, :update, :destroy]

  # GET /object_categories
  # GET /object_categories.json
  def index
    @object_categories = ObjectCategory.all
  end

  # GET /object_categories/1
  # GET /object_categories/1.json
  def show
  end

  # GET /object_categories/new
  def new
    @object_category = ObjectCategory.new
  end

  # GET /object_categories/1/edit
  def edit
  end

  # POST /object_categories
  # POST /object_categories.json
  def create
    @object_category = ObjectCategory.new(object_category_params)

    respond_to do |format|
      if @object_category.save
        format.html { redirect_to object_categories_url, notice: 'Object category was successfully created.' }
        format.json { render :show, status: :created, location: @object_category }
      else
        format.html { render :new }
        format.json { render json: @object_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /object_categories/1
  # PATCH/PUT /object_categories/1.json
  def update
    respond_to do |format|
      if @object_category.update(object_category_params)
        format.html { redirect_to object_categories_url, notice: 'Object category was successfully updated.' }
        format.json { render :show, status: :ok, location: @object_category }
      else
        format.html { render :edit }
        format.json { render json: @object_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /object_categories/1
  # DELETE /object_categories/1.json
  def destroy
    @object_category.destroy
    respond_to do |format|
      format.html { redirect_to object_categories_url, notice: 'Object category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_object_category
      @object_category = ObjectCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def object_category_params
      params.require(:object_category).permit(:name, :order, :hide)
    end
end
