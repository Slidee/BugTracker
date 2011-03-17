class ProjectsController < ApplicationController
  before_filter :check_authentication
  before_filter :check_is_admin, :only => [:index, :create, :destroy]

  def index
    @projects = Project.all
    @title = "Projects list"
  end
  
  def show
    @project = Project.find_by_slug params[:project_slug]
    @title = @project.name
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      flash[:success] = "Project successfully created"
    else
      flash[:error] = "Project present some invalid fields"
    end

    redirect_to projects_path
  end

  def destroy
    Project.find_by_slug(params[:project_slug]).destroy
    flash[:success] = "Project successfully Deleted"
    redirect_to projects_path
  end


end
