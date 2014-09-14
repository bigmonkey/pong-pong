Pdh::Application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  #match "/(*all)", constraints: {original_url: /\bherokuapp\b/}, to: "application#heroku"
 
  root to: 'homes#index'

  # Called from Wordpress site for header, footer, styles, and content
  get "jstyle" => "homes#jstyle"
  get "header" => "homes#header"
  get "footer" => "homes#footer"
  get "nav" => "homes#nav"
  get "loan-drop" => "homes#loan_drop"
  get "tracking_pixel" => "homes#tracking_pixel"

  # Old URL redirects to payday-loans
  get "lenders" => "lenders#index"

  # Routing for payday and installment loan finder sidebar
  get "lenders/finder" => "lenders#finder"

  # Payday loan application
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
  resources :applicants, path: "get-payday-loan"
  resources :borrowers
  resources :secureds, path: "secured-credit-cards", only: [:index, :show]
  resources :lenders, only: [:index, :show]
  resources :prepaids, path: "prepaid-cards", only: [:index, :show]
  resources :homes, only: :index
  resources :payday_loans, path: "payday-loans", only: [:index, :show]
  resources :term_loans, path: "installment-loans", only: [:index, :show]
  resources :payday_loan_laws, path: "payday-loan-laws", only: [:index, :show]
  resources :partners, only: [ :show ]
  resources :banners

  resources :topics, path: "learn/category/", only: [:index, :show]
  resources :articles, path: "learn/", only: [:index, :show]


  # Redirect old URLS to new URL's. Use redirect_to hardcard b/c of nginx/heroku/wordpress set up
  get "/prepaid-card/" => redirect("http://www.thepaydayhound.com/prepaid-cards/")
  match "/prepaid-card/:name/" => redirect("http://www.thepaydayhound.com/prepaid-cards/%{name}/"), via: :show
  get "/secureds/" => redirect("http://www.thepaydayhound.com/secured-credit-cards/")
  get "/prepaids/" => redirect("http://www.thepaydayhound.com/prepaid-cards/")
  get "/applicants" => redirect("http://www.thepaydayhound.com/get-payday-loan/")
  get "/payday-loans-direct-payday-lenders" => redirect("http://www.thepaydayhound.com/direct-payday-lenders-online/")
  get "/bad-credit-credit-card-secured-card" => redirect("http://www.thepaydayhound.com/learn/best-secured-credit-card")
  get "/find-apply-best-payday-loan-state" => redirect("http://www.thepaydayhound.com/learn/payday-loan-finder")
  get "/choosing-a-payday-loan" => redirect("http://www.thepaydayhound.com/learn/how-to-choose-a-payday-loan")
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
  get ':controller/:action', controller: /infos|blogbars/ 
  
  get "/why-use-the-payday-hound/" => "infos#about"  

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  # These routes are based on Keywords table. The classes below are defined in ../lib/routes.rb
  match "*stuff/:id", to: 'term_loans#show', constraints: SEOTermState.new, via: :get
  match "*stuff/:id", to: 'payday_loans#show', constraints: SEOPaydayState.new, via: :get
  match "*stuff", to: 'term_loans#index', constraints: SEOTermIndex.new, via: :get
  match "*stuff", to: 'payday_loans#index', constraints: SEOPaydayIndex.new, via: :get    

  #match "*stuff" => "application#wp", via: :all
end
