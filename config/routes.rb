Pdh::Application.routes.draw do

  match "/(*all)", constraints: {original_url: /\blocalhost\b/}, to: "application#heroku"

  root :to => 'homes#index'

  # Called from Wordpress site for header, footer and styles
  get "jstyle" => "homes#jstyle"
  get "header" => "homes#header"
  get "footer" => "homes#footer"

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
  resources :applicants, :path => "get-payday-loan"
  resources :borrowers
  resources :secureds, :path => "secured-credit-cards", :only => [:index, :show]
  resources :lenders, :only => [:index, :show]
  resources :prepaids, :path => "prepaid-cards", :only => [:index, :show]
  resources :homes, :only => :index
  resources :payday_loans, :path => "payday-loans", :only => [:index, :show]
  resources :term_loans,:path => "installment-loans", :only => [:index, :show]
  resources :payday_loan_laws, :path => "payday-loan-laws", :only => [:index, :show]
  resources :partners, :only => [ :index, :show ]


  # Term Loan URL's based on Nov 3, 2013 SEO analysis
  resources :term_loans,:path => "short-term-installment-loans", :only => [:index, :show]
  resources :term_loans,:path => "installment-loans-online", :only => [:index, :show]
  resources :term_loans,:path => "bad-credit-installment-loans", :only => [:index, :show]

  resources :term_loans,:path => "online-installment-loan-direct-lenders", :only => [:index, :show]
  resources :term_loans,:path => "installment-loan-lenders", :only => [:index, :show]
  resources :term_loans,:path => "bad-credit-installment-loan-direct-lenders", :only => [:index, :show]
  resources :term_loans,:path => "direct-installment-loan-lenders", :only => [:index, :show]

  # Payday Loan URL's based on Nov 3, 2013 SEO analysis
  resources :payday_loans,:path => "direct-lender-payday-loans", :only => [:index, :show]
  resources :payday_loans,:path => "online-payday-loans", :only => [:index, :show]
  resources :payday_loans,:path => "payday-loans-online", :only => [:index, :show]
  resources :payday_loans,:path => "pay-day-loans-online", :only => [:index, :show]
  resources :payday_loans,:path => "payday-advances", :only => [:index, :show]
  resources :payday_loans,:path => "online-cash-advances", :only => [:index, :show]

  resources :payday_loans,:path => "payday-loan-direct-lenders", :only => [:index, :show]
  resources :payday_loans,:path => "direct-payday-lenders-online", :only => [:index, :show]
  resources :payday_loans,:path => "payday-lenders", :only => [:index, :show]
  resources :payday_loans,:path => "online-payday-lenders", :only => [:index, :show]
  resources :payday_loans,:path => "direct-lenders-for-payday-loans", :only => [:index, :show]
  resources :payday_loans,:path => "direct-online-payday-lenders", :only => [:index, :show]
  resources :payday_loans,:path => "direct-payday-loan-lenders", :only => [:index, :show]

  #URLS from previous blog
  resources :payday_loans,:path => "borrow-money-options", :only => [:index, :show]
  resources :payday_loans,:path => "ez-payday", :only => [:index, :show]  
  resources :term_loans,:path => "fast-cash-loan", :only => [:index, :show]  
  resources :term_loans,:path => "fast-loan", :only => [:index, :show] 
  resources :payday_loans,:path => "instant-payday-loans", :only => [:index, :show]
  resources :payday_loans,:path => "no-credit-check-payday-loans", :only => [:index, :show]  
  resources :payday_loans,:path => "payday-loan-in-an-hour", :only => [:index, :show]
  resources :payday_loans,:path => "quick-payday-loans", :only => [:index, :show]  
  resources :term_loans,:path => "quik-cash-loans", :only => [:index, :show]  
  resources :term_loans,:path => "quick-fast-loans", :only => [:index, :show] 
  resources :payday_loans,:path => "no-faxing-payday", :only => [:index, :show]
 




  # Redirect old URLS to new URL's. Use redirect_to hardcard b/c of nginx/heroku/wordpress set up
  match "/prepaid-card/" => redirect("http://www.thepaydayhound.com/prepaid-cards/")
  match "/prepaid-card/:name/" => redirect("http://www.thepaydayhound.com/prepaid-cards/%{name}/")
  match "/secureds/" => redirect("http://www.thepaydayhound.com/secured-credit-cards/")
  match "/prepaids/" => redirect("http://www.thepaydayhound.com/prepaid-cards/")
  match "/why-use-the-payday-hound/" => redirect("http://www.thepaydayhound.com")
  match "/applicants" => redirect("/get-payday-loan/")
  match "/payday-loans-direct-payday-lenders" => redirect("/direct-payday-lenders-online/")
  match "/bad-credit-credit-card-secured-card" => redirect("/learn/best-secured-credit-card")
  match "/find-apply-best-payday-loan-state" => redirect("/learn/payday-loan-finder")
  match "/choosing-a-payday-loan" => redirect("/learn/how-to-choose-a-payday-loan")
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
  

  match "*rest" => "application#wp"
end
