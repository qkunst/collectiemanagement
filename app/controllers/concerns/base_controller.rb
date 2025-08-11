# frozen_string_literal: true

module BaseController
  extend ActiveSupport::Concern

  included do
    before_action :set_collection
    before_action :set_named_variable_by_class, only: [:show, :edit, :update, :destroy]
    before_action :authentication_callbacks
    helper_method :controlled_class

    def index
      self.named_collection_variable = if @collection
        controlled_class.where(collection_id: @collection.id).all
      else
        controlled_class.all
      end

      render base_view? ? "base/index" : nil
    end

    def show
      render base_view? ? "base/show" : nil
    end

    def new
      self.named_variable = controlled_class.new
      named_variable.collection = @collection if @collection
      render base_view? ? "base/new" : nil
    end

    def create
      self.named_variable = controlled_class.new(white_listed_params)
      named_variable.collection = @collection.base_collection if @collection

      if named_variable.save
        redirect_to named_collection_url, notice: "#{I18n.t(singularized_name, scope: [:activerecord, :models])} is gemaakt"
      else
        render base_view? ? "base/new" : nil
      end
    end

    def update
      if named_variable.update(white_listed_params)
        redirect_to named_collection_url, notice: "#{I18n.t(singularized_name, scope: [:activerecord, :models])} is bijgewerkt."
      else
        render base_view? ? "base/edit" : nil
      end
    end

    def edit
      render base_view? ? "base/edit" : nil
    end

    def destroy
      named_variable.destroy
      redirect_to named_collection_url, notice: "#{I18n.t(singularized_name, scope: [:activerecord, :models])} is verwijderd."
    end

    private

    def authentication_callbacks
      if @collection && !(named_variable.methods.include?(:collection) && named_variable.collection.nil?)
        if ["index", "show"].include? action_name.to_s
          authorize! :review_collection, controlled_class
        else
          authorize! :manage_collection, controlled_class
        end
      else
        authorize! :index, controlled_class
      end
    end

    def named_collection_url
      @collection ? send(:"collection_#{controlled_class.table_name}_url", @collection) : send(:"#{controlled_class.table_name}_url")
    end

    def singularized_name
      controlled_class.table_name.singularize
    end

    def base_view? = false

    def named_collection_variable= values
      @subjects = values
      instance_variable_set(:"@#{controlled_class.table_name}", values)
    end

    def named_variable= value
      @subject = value
      instance_variable_set(:"@#{singularized_name}", value)
    end

    def named_variable
      instance_variable_get(:"@#{singularized_name}")
    end

    def set_named_variable_by_class
      self.named_variable = controlled_class.find(params[:id])
    end

    def white_listed_params
      params.require(singularized_name.to_sym).permit(:name, :description, :order, :hide, :collection_id)
    end
  end
end
