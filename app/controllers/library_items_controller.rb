class LibraryItemsController < ApplicationController
  before_action :set_collection
  before_action :set_subject

  before_action :set_library_item, only: [:show, :edit, :update, :destroy]

  authorize_resource
  # GET /library_items
  # GET /library_items.json
  def index
    @library_items = @subject ? @subject.library_items.order(stock_number: :asc).all : @collection.library_items_including_child_library_items.order(stock_number: :asc).all
  end

  # GET /library_items/1
  # GET /library_items/1.json
  def show
  end

  # GET /library_items/new
  def new
    @library_item = @collection.base_collection.library_items.new
    @library_item.works << @work if @work
    @library_item.artists << @artist if @artist

    @library_items = @collection.library_items_including_parent_library_items.all
    @library_items -= @subject.library_items if @subject
  end

  # GET /library_items/1/edit
  def edit
  end

  # POST /library_items
  # POST /library_items.json
  def create
    @library_item = @collection.base_collection.library_items.new(library_item_params)

    if @library_item.save
      @library_item.works << @work if @work
      @library_item.artists << @artist if @artist

      redirect_to [@collection.base_collection, @library_item], notice: 'Het item is toegevoegd aan de bibliotheek'
    else
      render :new
    end
  end

  # PATCH/PUT /library_items/1
  # PATCH/PUT /library_items/1.json
  def update
    if @library_item.update(library_item_params)
      redirect_to [@collection, @library_item], notice: 'Het item is bijgewerkt'
    else
      render :edit
    end
  end

  # DELETE /library_items/1
  # DELETE /library_items/1.json
  def destroy
    if @subject
      @subject.library_items -= [@library_item]
      notice = "Item verwijderd bij #{I18n.t @subject.class.name.downcase, :activerecord, :models}"
    else
      notice = "Item volledig verwijderd"
      @library_item.destroy
    end

    redirect_to collection_library_items_url(@collection), notice: notice
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library_item
      @library_item = @collection.library_items_including_child_library_items.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def library_item_params
      a_params = params.require(:library_item).permit(:item_type, :title, :author, :ean, :stock_number, :location, :description, :thumbnail, append_work_ids: [], append_artist_ids: [])
      a_params[:append_works] = current_user.accessible_works.where(id: a_params.delete(:append_work_ids))
      a_params[:append_artists] = current_user.accessible_artists.where(id: a_params.delete(:append_artist_ids))
      a_params
    end

    def set_subject
      if params[:work_id]
        @work = current_user.accessible_works.find(params[:work_id])
      end
      if params[:artist_id]
        @artist = current_user.accessible_artists.find(params[:artist_id])
      end
      @subject = @work || @artist
    end
end
