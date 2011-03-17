BugTracker::Application.routes.draw do

  ###################
  ### Admin Screens
  scope "/admin" do
    resources :users
    resources :projects,  :only => [:index, :create]
    match "/projects/destroy/:project_slug" , :to => "projects#destroy"
  end


  ###################
  ### Sessions management
  resources :sessions
  match "/signin" , :to => "sessions#new"
  match "/signout" , :to => "sessions#destroy"


  ###################
  ### Static pages
  match "/help", :to => "pages#help"
  match "/report", :to => "pages#report"
  match "/about", :to => "pages#about"

  
  ###################
  ### Dynamic, projects and sprint routes
  match "/:project_slug" , :to => "projects#show"



  root :to => "pages#home"
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
