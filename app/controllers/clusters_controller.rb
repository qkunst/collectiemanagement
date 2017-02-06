class ClustersController < ApplicationController
  before_action :authenticate_qkunst_user! #, only: [:clean]

  before_action :set_collection
  before_action :set_cluster, only: [:show, :edit, :update, :destroy]

  # GET /clusters
  # GET /clusters.json
  def index
    @clusters = @collection.clusters.all
  end

  # GET /clusters/1
  # GET /clusters/1.json
  def show
  end

  # GET /clusters/new
  def new
    @cluster = Cluster.new
  end

  # GET /clusters/1/edit
  def edit
  end

  # POST /clusters
  # POST /clusters.json
  def create
    @cluster = Cluster.new(cluster_params)
    @cluster.collection = @collection
    respond_to do |format|
      if @cluster.save
        format.html { redirect_to collection_path(@collection), notice: "Het cluster '#{@cluster.name}' is aangemaakt." }
        format.json { render :show, status: :created, location: @cluster }
      else
        format.html { render :new }
        format.json { render json: @cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clusters/1
  # PATCH/PUT /clusters/1.json
  def update
    respond_to do |format|
      if @cluster.update(cluster_params)
        format.html { redirect_to collection_works_path(@collection, {filter: {"cluster_id"=>[@cluster.id]}}), notice: 'Het cluster is bijgewerkt' }
        format.json { render :show, status: :ok, location: @cluster }
      else
        format.html { render :edit }
        format.json { render json: @cluster.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clusters/1
  # DELETE /clusters/1.json
  def destroy
    @cluster.destroy
    respond_to do |format|
      format.html { redirect_to collection_works_url(@collection), notice: 'Het cluster is verwijderd.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cluster
      @cluster = Cluster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cluster_params
      params.require(:cluster).permit(:name, :description)
    end
end
