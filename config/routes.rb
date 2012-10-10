Sherlock::Application.routes.draw do
    
  devise_for :users, :controllers => {
    :sessions       => 'sessions',
    :registrations  => 'registrations'
  }
  
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  
  resources :text_snippets
  resources :letterheads
  resources :logos
  resources :clients
  resources :folders
  resources :reports
  
  resources :contact_messages
  
  resources :block_swaps, :only => [ :create ]  
  
  resources :captured_emails
  
  resources :purchases
  
  resources :subscription_plans
  
  resources :events
  
  resources :file_assets
    
  resources :impersonations  
  
  resources :cases do
    resources :html_details
    resources :data_log_details
    resources :witness_statements
    resources :pictures
    resources :videos
    resources :invitations
    resources :footers
    resources :notes
    resources :viewers
  end
  
  namespace :dashboard do
    resources :users    
    resources :clients
    resources :client_conversions, :only => [:new, :create]
  end
  
  scope '/chargify' do
    get  'subscriptions/new'  => 'chargify/subscriptions#new'
    post 'events/create'      => 'chargify/events#create'
  end  
  
  post 'folders/:id/move_case'      => 'folders#move_case'
  post 'folders/:id/move_out_case'  => 'folders#move_out_case'
    
  resource :account, :only => [:show, :update]
 
  get 'search/index'  => 'search#index', :as => :search
  
  get 'account/upgrade' => 'accounts#upgrade', :as => :upgrade
  get 'account/renew' => 'accounts#renew', :as => :renew
  
  get 'cases/preview/:id' => 'cases#preview', :as => :case_preview
  
  match 'spellcheck/lookup' => 'spellcheck#lookup', 
        :as => :spellcheck, :via => [:get, :post]
  
  post  'temp_videos/exists'  => 'temp_videos#exists', :as => :check_temp_video
  put   'temp_videos'         => 'temp_videos#create', :as => :new_temp_video
  
  get 'dashboard' => 'home#dashboard',  :as => :dashboard
  
  get 'pricing'   => 'home#pricing',    :as => :pricing
  get 'help'      => 'home#help',       :as => :help  
  get 'contact'   => 'home#contact',    :as => :contact
  get 'tos'       => 'home#tos',        :as => :tos
  get 'privacy'   => 'home#privacy',    :as => :privacy
  
  resources :blocks
  
  get 'logo/:filename' => 'files#logo',
    :constraints => { :filename => /.*/ }, :as => :logo
  
  get 'files/:case_id/:type/:filename' => 'files#show',
    :constraints => { :filename => /.*/ }, :as => :file
  
  get 'video_thumbnails/:case_id/:filename' => 'files#video_thumbnail',
    :constraints => { :filename => /.*/ }, :as => :file_video_thumbnail
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
