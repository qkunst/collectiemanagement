# frozen_string_literal: true

module UitleenHelper
  def uitleen_work_url work
    if Rails.application.secrets.uitleen_site
      collection_id = work.collection_id
      work_id = work.is_a?(Work) ? work.id : work
      File.join(Rails.application.secrets.uitleen_site, "collections", collection_id.to_s, "works", work_id.to_s)
    end
  end

  def uitleen_new_draft_invoice_url params = {}
    if Rails.application.secrets.uitleen_site
      invoiceable_item_collection = params.delete(:invoiceable_item_collection)
      if invoiceable_item_collection
        params[:invoiceable_item_collection_type] = "CollectionManagement::#{invoiceable_item_collection.class.name}"
        params[:invoiceable_item_collection_external_id] = invoiceable_item_collection.external_id
      end
      uri = URI.parse(Rails.application.secrets.uitleen_site)
      uri.path = "/draft_invoices/new"
      uri.query = params.to_query
      uri.to_s
    end
  end
end
