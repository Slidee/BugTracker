class UsersController < ApplicationController
  before_filter :check_authentication
  #before_filter :check_is_admin, :only => [:index]
  before_filter :check_is_admin_or_target
  before_filter :check_target_is_not_me, :only => :destroy

  def index
    @users = User.paginate(:page => params[:page])
    @title = "Users list"
  end

  def show
    @user = User.find(params[:id])
    @title = "User " + @user.username
  end

  def new
    @user = User.new()
    @title = "New user"
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit user '" + @user.username + "'"
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:success] = "User '" + @user.username + "'have successully been created"
      redirect_to @user
    else
      @title = "New user"
      @user.password = ""
      @user.password_confirmation = ""
      render "new"
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile has been updated successfully"
      redirect_to @user
    else
      @title = "Edit user '" + @user.username + "'"
      @user.password = ""
      @user.password_confirmation = ""
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    redirect_to users_path
  end

  private

    def check_target_is_not_me
      restrict_access if is_the_current_user? User.find(params[:id])
    end

    def check_is_admin_or_target
      restrict_access unless signed_in? && (current_user.admin? || (!params[:id].blank? && is_the_current_user?(User.find(params[:id]))))
    end
    
end
