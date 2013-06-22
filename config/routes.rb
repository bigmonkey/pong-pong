Pdh::Application.routes.draw do

  root :to => 'homes#index'

  get "jstyle" => "homes#jstyle"

  get "header" => "homes#header"
  
  get "footer" => "homes#footer"

  get "lenders" => "lenders#index"

  get "lenders/finder" => "lenders#finder"

  post "/borrowers/new" => "borrowers#new"

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
  # Create SEO friendly URL keeping original path names
  resources :applicants, :path => "get-payday-loan"
  resources :borrowers
  resources :secureds, :path => "secured-credit-cards", :only => [:index, :show]
  resources :lenders, :only => [:index, :show]
  resources :prepaids, :path => "prepaid-cards", :only => [:index, :show]
  resources :homes, :only => :index
  resources :payday_loans, :path => "payday-loans", :only => [:index, :show]
  resources :term_loans, :path => "installment-loans", :only => [:index, :show]
  resources :payday_loan_laws, :path => "payday-loan-laws", :only => [:index, :show]
  resources :partners, :only => [ :index, :show ]

  # Redirect old URLS to new URL's. Use redirect_to hardcard b/c of nginx/heroku/wordpress set up
  match "/prepaid-card/" => redirect("http://www.thepaydayhound.com/prepaid-cards/")
  match "/prepaid-card/:name" => redirect("http://www.thepaydayhound/prepaid-cards/%{name}/")
  match "/secureds/" => redirect("http://www.thepaydayhound/secured-credit-cards/")
  match "/prepaids/" => redirect("http://www.thepaydayhound/prepaid-cards/")

  # Another way to create SEO friendly URL's 
  #resources "payday-loans", :as => :payday_loans, :controller => :payday_loans
  
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # Non-RESTful Routes
  # infos is site information
  # blogbars are sidebars for Wordpress and show action for prepaids and secureds
  get ':controller/:action', :controller => /infos|blogbars/ 
  

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
