class SubsetsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_subset, only: [:show, :edit, :update, :destroy]

  # GET /subsets
  # GET /subsets.json
  def index
    @subsets = Subset.all
  end

  # GET /subsets/1
  # GET /subsets/1.json
  def show
  end

  # GET /subsets/new
  def new
    @subset = Subset.new
  end

  # GET /subsets/1/edit
  def edit
  end

  # POST /subsets
  # POST /subsets.json
  def create
    @subset = Subset.new(subset_params)

    respond_to do |format|
      if @subset.save
        format.html { redirect_to subsets_url, notice: 'Subset was successfully created.' }
        format.json { render :show, status: :created, location: @subset }
      else
        format.html { render :new }
        format.json { render json: @subset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subsets/1
  # PATCH/PUT /subsets/1.json
  def update
    respond_to do |format|
      if @subset.update(subset_params)
        format.html { redirect_to subsets_url, notice: 'Subset was successfully updated.' }
        format.json { render :show, status: :ok, location: @subset }
      else
        format.html { render :edit }
        format.json { render json: @subset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subsets/1
  # DELETE /subsets/1.json
  def destroy
    @subset.destroy
    respond_to do |format|
      format.html { redirect_to subsets_url, notice: 'Subset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subset
      @subset = Subset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subset_params
      params.require(:subset).permit(:name, :order, :hide)
    end
end
