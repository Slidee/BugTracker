BugTracker::Application.routes.draw do

  scope "/admin" do
    resources :users
  end


  resources :sessions
  match "/signin" , :to => "sessions#new"
  match "/signout" , :to => "sessions#destroy"

  match "/help", :to => "pages#help"
  match "/report", :to => "pages#report"
  match "/about", :to => "pages#about"
  root :to => "pages#home"
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
