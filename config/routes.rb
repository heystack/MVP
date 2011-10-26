Mvp::Application.routes.draw do
  resources :topics do
    resources :responses
  end
  get "topics/new"
  get "topics/show"

  resources :responses
  match '/response',  :to => 'responses#new'
  match '/stkresponses',       :to => 'responses#stkresponses'

  get "responses/new"
  get "responses/show"

  get "mvp/home"
  get "mvp/contact"
  
  match '/send_stack_form',     :to => 'mvp#send_stack_form'
  match '/suggestion_form',     :to => 'mvp#suggestion_form'
  match '/send_suggestion',     :to => 'mvp#send_suggestion'
  match '/suggestion',          :to => 'mvp#suggestion'
  match '/sample_email',        :to => 'mvp#sample_email'
  match '/email_preview',       :to => 'mvp#email_preview'
  match '/share_with_neighbor', :to => 'mvp#share_with_neighbor'

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
  root :to => "mvp#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
