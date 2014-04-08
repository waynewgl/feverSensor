FunnyRLife::Application.routes.draw do
  apipie

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

  #resources :user


  root :to => 'user#index'

  match 'user/index' => 'user#index'
  match 'user/user_login' => 'user#user_login'
  match 'user/getUser' => 'user#getUser'
  match 'user/register' => 'user#register'
  match 'user/dev_pushTest' => 'user#dev_pushTest'
  match 'user/pro_pushTest' => 'user#pro_pushTest'

  match 'user/upload_avatar_ios' => 'user#upload_avatar_ios'
  match 'user/userFavoriatePost' => 'user#userFavoriatePost'
  match 'user/updateProfile' => 'user#updateProfile'
  match 'user/followUser' => 'user#followUser'
  match 'user/cancelFollowUser' => 'user#cancelFollowUser'
  match 'user/blackList' => 'user#blackList'
  match 'user/removeBlackList' => 'user#removeBlackList'
  match 'user/updateLocation' => 'user#updateLocation'
  match 'user/userNickname' => 'user#userNickname'

  match 'post/listUserPosts' => 'post#listUserPosts'
  match 'post/createPost' => 'post#createPost'
  match 'post/getSpecificPost' => 'post#getSpecificPost'
  match 'post/searchPost' => 'post#searchPost'
  match 'post/addAttachment' => 'post#addAttachment'
  match 'post/deleteAttachment' => 'post#deleteAttachment'
  match 'post/listPostComments' => 'post#listPostComments'

  match 'comment/createComment' => 'comment#createComment'
  match 'comment/addAttachment' => 'comment#addAttachment'
  match 'comment/deleteAttachment' => 'comment#deleteAttachment'

  match 'record/addRecordGroup' => 'comment#addRecordGroup'
  match 'record/addRecordTemperature' => 'comment#addRecordTemperature'


  match 'admin/index' => 'admin#index'
  match 'admin/upload_avatar' => 'admin#upload_avatar'
  match 'admin/upload_avatar_ios' => 'admin#upload_avatar_ios'


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
