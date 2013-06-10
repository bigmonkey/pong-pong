Pdh::Application.routes.draw do

  root :to => 'homes#index'

  get "jstyle" => "homes#jstyle"

  get "header" => "homes#header"
  
  get "footer" => "homes#footer"

  get "lenders" => "lenders#index"

  get "lenders/finder" => "lenders#finder"

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
  resources :applicants
  resources :borrowers
  resources :secureds
  resources :lenders
  resources :prepaids
  resources :homes
  resources :payday_loans
  resources :term_loans
  resources :payday_loan_laws
  resources :partners

  resources "payday-loans", :as => :payday_loans, :controller => :payday_loans
  resources "installment-loans", :as => :term_loans, :controller => :term_loans
  resources "payday-loan-laws", :as => :payday_loan_laws, :controller => :payday_loan_laws
  resources "payday-loan-apply", :as => :applicants, :controller => :applicants
  resources "prepaid-card", :as => :prepaids, :controller => :prepaids  
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

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'

end
