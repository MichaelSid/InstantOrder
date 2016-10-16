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


  
  post 'reply' => 'send_texts#reply'



  get 'message', to: 'send_texts#show_all', as: 'sms_home'
  get 'message/:id', to: 'send_texts#show', as: 'show_id'
  get 'contractor/new', to: 'send_texts#new'
  post 'contractor/new', to: 'send_texts#create', as: 'contractor'


  patch 'message/:id', to: 'send_texts#update', as: 'show_id_update'
  post 'message/sms', to: 'send_texts#send_sms', as: 'send_sms'
  post 'message/sms_body', to: 'send_texts#sms_body', as: 'sms_body'

  get 'sms/contractors', to: 'send_texts#contractors_sms'
  post 'sms/send', to: 'send_texts#contractors_send', as: 'contractors_send'


  get 'import', to: 'send_texts#import_csv'
  post 'import', to: 'send_texts#import_contractors', as: 'import_csv_contractors'


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
