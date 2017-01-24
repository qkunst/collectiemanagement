class InvolvementsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_involvement, only: [:show, :edit, :update, :destroy]

  # GET /involvements
  # GET /involvements.json
  def index
    @involvements = Involvement.all
  end

  # GET /involvements/1
  # GET /involvements/1.json
  def show
  end

  # GET /involvements/new
  def new
    @involvement = Involvement.new
  end

  # GET /involvements/1/edit
  def edit
  end

  # POST /involvements
  # POST /involvements.json
  def create
    @involvement = Involvement.new(involvement_params)

    respond_to do |format|
      if @involvement.save
        format.html { redirect_to @involvement, notice: 'Involvement was successfully created.' }
        format.json { render :show, status: :created, location: @involvement }
      else
        format.html { render :new }
        format.json { render json: @involvement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /involvements/1
  # PATCH/PUT /involvements/1.json
  def update
    respond_to do |format|
      if @involvement.update(involvement_params)
        format.html { redirect_to @involvement, notice: 'Involvement was successfully updated.' }
        format.json { render :show, status: :ok, location: @involvement }
      else
        format.html { render :edit }
        format.json { render json: @involvement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /involvements/1
  # DELETE /involvements/1.json
  def destroy
    @involvement.destroy
    respond_to do |format|
      format.html { redirect_to involvements_url, notice: 'Involvement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_involvement
      @involvement = Involvement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def involvement_params
      params.require(:involvement).permit(:name, :city, :country, :type)
    end
end
