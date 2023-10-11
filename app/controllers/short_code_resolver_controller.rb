class ShortCodeResolverController < ApplicationController
  skip_before_action :authenticate_activated_user!

  def resolve
    # "short_code_resolver/resolve/:collection_code/:work_code"
    raise ActiveRecord::RecordNotFound.new("not found") if params[:collection_code].blank?

    collection = Collection.find_by_unique_short_code!(params[:collection_code])
    work = collection.works_including_child_works.find_by_stock_number!(params[:work_code])

    redirect_to collection_work_path(collection, work)
  end
end
