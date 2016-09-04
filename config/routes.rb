Rails.application.routes.draw do

  devise_for :accounts, :controllers => { registrations: 'registrations', sessions: 'sessions' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'home#main'
  # get 'creatives/index'
  root 'creatives#index'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):

  resources :orders
  resources :charges
  
  get 'contact', to: 'messages#new', as: 'contact'
  post 'contact', to: 'messages#create' 
  get "/pages/:page" => "pages#show", as: :static_pages
  get '/sitemap.xml.gz', to: redirect("https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/sitemaps/sitemap.xml.gz"), as: :sitemap

  get '/history', to: 'orders#history', as: 'orders_all'
  get 'history/:id', to: 'orders#show', as: 'order_id'
  get 'pdf/:id', to: 'orders#pdf', as: 'order_pdf'

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
