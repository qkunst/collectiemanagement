class SimpleImportCollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection
  before_action :set_simple_import_collection, only: [:show, :update]

  def index
    @import_collections = @collection.simple_import_collections.order(created_at: :desc)
  end

  def new
    @simple_import_collection = SimpleImportCollection.new({collection: @collection})
    @works = []
    render :show
  end

  def create
    @simple_import_collection = SimpleImportCollection.new(simple_import_collection_params.merge(collection: @collection).merge(SimpleImportCollection::DEFAULT_SETTINGS))
    if @simple_import_collection.save
      redirect_to collection_simple_import_collection_path(@collection, @simple_import_collection)
    else
      render :show
    end
  end

  def update
    if @simple_import_collection.update(simple_import_collection_params)
      if params[:write]
        @simple_import_collection.write
      end
      redirect_to collection_simple_import_collection_path(@collection, @simple_import_collection)
    else
      render :show
    end
  end

  def show
    @work_display_form = WorkDisplayForm.new(current_user:, display: :complete)
    @works = @simple_import_collection.read
  end

  private

  def simple_import_collection_params
    params.require(:simple_import_collection).permit(:file, :primary_key, :decimal_separator)
  end

  def set_simple_import_collection
    @simple_import_collection = @collection.simple_import_collections.find(params[:id])
  end
end
