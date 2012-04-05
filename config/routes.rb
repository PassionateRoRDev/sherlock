Sherlock::Application.routes.draw do
  
  devise_for :users, :controllers => {
    :registrations => 'registrations'
  }
  
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  
  resources :letterheads
  resources :logos
  resources :clients
  resources :folders
  
  resources :cases do
    resources :html_details
    resources :pictures
    resources :videos
    resources :invitations
    resources :footers
    resources :notes
  end
    
  resource :account, :only => [:show, :update]
 
  get 'cases/preview/:id' => 'cases#preview', :as => :case_preview
  
  match 'spellcheck/lookup' => 'spellcheck#lookup', 
        :as => :spellcheck, :via => [:get, :post]
  
  get 'dashboard' => 'home#dashboard',  :as => :dashboard
  
  get 'pricing'   => 'home#pricing',    :as => :pricing
  get 'tour'      => 'home#tour',       :as => :tour
  get 'help'      => 'home#help',       :as => :help
  get 'customers' => 'home#customers',  :as => :customers
  
  resources :blocks
  
  match 'files/:case_id/:type/:filename' => 'files#show',
    :constraints => { :filename => /.*/ }, :as => :file
  
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
