class ContactsController < ApplicationController
  before_action :set_collection
  before_action :set_contact, only: %i[show edit update destroy]

  # GET /contacts or /contacts.json
  def index
    authorize! :read, Contact

    @contacts = @collection.contacts.all
  end

  # GET /contacts/1 or /contacts/1.json
  def show
    authorize! :read, @contact
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    authorize! :create, @contact
  end

  # GET /contacts/1/edit
  def edit
    authorize! :update, @contact
  end

  # POST /contacts or /contacts.json
  def create
    @contact = Contact.new(contact_params)
    @contact.collection = @collection
    authorize! :create, @contact

    if @contact.save
      redirect_to [@collection, @contact], notice: "Contact is toegevoegd."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    authorize! :update, @contact

    if @contact.update(contact_params)
      redirect_to [@collection, @contact], notice: "Contact is bijgewerkt."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1 or /contacts/1.json
  def destroy
    authorize! :destroy, @contact
    @contact.destroy
    redirect_to collection_contacts_url(@collection), notice: "Contact is verwijderd."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = @collection.contacts.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contact_params
    params.require(:contact).permit(:address, :name, :url)
  end
end
