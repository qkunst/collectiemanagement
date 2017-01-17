
Rails.application.routes.draw do


  namespace :api do
    namespace :v1 do
      resources :collections, only: [] do
        resources :works, only: [:index]
      end
    end
  end

  resources :messages do
    get 'new_reply' => 'messages#new'
  end
  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  resources :users, only: [:index, :edit, :update, :destroy]
  resources :currencies
  resources :placeabilities
  resources :subsets
  resources :themes
  resources :styles
  resources :sources
  resources :frame_damage_types
  resources :damage_types
  resources :conditions
  resources :media
  resources :techniques
  resources :object_categories
  resources :rkd_artists

  rack_offline = Rack::Offline.configure :cache_interval => 3600 do
    # cache "images/masthead.png"
    cache "/testscript.js" if Rails.env == "dfevelopment"

    settings "prefer-online"

    action_view = ActionView::Base.new
    action_view.stylesheet_link_tag("application").split("\n").collect{|a|          cache a.match(/href=\"(.*)\"/)[1] }
    action_view.javascript_include_tag("application").split("\n").collect{|a|       cache a.match(/src=\"(.*)\"/)[1] }

    network "/heartbeat"
    network "/uploads/work"
    network "*"

    fallbacks = {}
    fallbacks["/artists"] = "/artists?offline=offline"
    fallbacks["/geoname_summaries.json"] = "/geoname_summaries.json?offline=offline"
    fallbacks["/collections"] = "/collections?offline=offline"
    begin
      Collection.all.each do |collection|
        fallback["/collections/#{collection.to_param}"] = "collections/#{collection.to_param}?offline=offline"
        fallback["/collections/#{collection.to_param}/works"] = "collections/#{collection.to_param}/works?offline=offline"
        fallback["/collections/#{collection.to_param}/works/new"] = "collections/#{collection.to_param}/works/new?offline=offline"
        fallback["/collections/#{collection.to_param}/works/new?test"] = "collections/#{collection.to_param}/works/new?test=test&offline=offline" if Rails.env != "develfopment"
      end
    rescue
      puts "Table Collection doesn't exist (yet)"

    end
    fallbacks["/debug-offline"] = "/debug-offline?offline=offline"
    fallback(fallbacks)
  end

  get "/application.manifest" => rack_offline #if Rails.env != "development"

  resources :involvements
  resources :collections do
    resources :messages
    post 'refresh_works' => 'collections#refresh_works'
    resources :collections do
    end
    resources :themes
    resources :batch_photo_uploads do
      post 'match_works' => 'batch_photo_uploads#match_works'
    end
    resources :artists
    resources :import_collections do
      get 'preview' => 'import_collections#preview'
      patch 'delete_works' => 'import_collections#delete_works'
      patch 'import_works' => 'import_collections#import_works'
    end
    resources :works do
      resources :messages
      get 'edit_location' => 'works#edit_location'
      patch 'update_location' => 'works#update_location'
    end
    resources :clusters
    get 'report' => 'collections#report'
  end
  resources :artists do
    get 'combine_prepare' => 'artists#combine_prepare'
    patch 'combine' => 'artists#combine'
    get 'rkd_artists' => 'artists#rkd_artists'
    resources :artist_involvements
  end
  post '/artists/clean' => 'artists#clean'


  resources :professional_activities

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get "debug-offline" => 'application#debug_offline'
  get "heartbeat" => 'application#heartbeat'
  get "admin" => 'application#admin'
  get "geoname_summaries" => 'application#geoname_summaries'
  # You can have the root of your site routed with "root"
  root 'application#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
