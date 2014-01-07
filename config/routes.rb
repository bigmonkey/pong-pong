Pdh::Application.routes.draw do
  #match "/(*all)", constraints: {original_url: /\bherokuapp\b/}, to: "application#heroku"

  root to: 'homes#index'

  # Called from Wordpress site for header, footer and styles
  get "jstyle" => "homes#jstyle"
  get "header" => "homes#header"
  get "footer" => "homes#footer"
  get "nav" => "homes#nav"
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
  #resources :term_loans, path: "short-term-installment-loans", only: [:index, :show]

  # Payday and Term Loan URL's based on Nov 3, 2013 SEO analysis
  # And also URLS from previous blog
  # Excludes routes for payday_loans and term_loans controller as they are above
  Keyword.all.where.not(word: ["installment loans","payday loans"]).each do |k|
    resources (k.controller + '_loans').parameterize.to_sym, path: k.word.gsub(' ','-'), only: [:index, :show]
  end  


  # Redirect old URLS to new URL's. Use redirect_to hardcard b/c of nginx/heroku/wordpress set up
  get "/prepaid-card/" => redirect("http://www.thepaydayhound.com/prepaid-cards/")
  match "/prepaid-card/:name/" => redirect("http://www.thepaydayhound.com/prepaid-cards/%{name}/"), via: :show
  get "/secureds/" => redirect("http://www.thepaydayhound.com/secured-credit-cards/")
  get "/prepaids/" => redirect("http://www.thepaydayhound.com/prepaid-cards/")
  get "/why-use-the-payday-hound/" => redirect("http://www.thepaydayhound.com")
  get "/applicants" => redirect("/get-payday-loan/")
  get "/payday-loans-direct-payday-lenders" => redirect("/direct-payday-lenders-online/")
  get "/bad-credit-credit-card-secured-card" => redirect("/learn/best-secured-credit-card")
  get "/find-apply-best-payday-loan-state" => redirect("/learn/payday-loan-finder")
  get "/choosing-a-payday-loan" => redirect("/learn/how-to-choose-a-payday-loan")
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
  

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  

  match "*rest" => "application#wp", via: :all
end
