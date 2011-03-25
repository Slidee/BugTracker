class ConfigController < ApplicationController
  before_filter :check_authentication
  before_filter :check_is_admin
  def index
    @task_statuses = TaskStatus.order(:name).all 
    @task_priorities = TaskPriority.order(:position).all
    @title = "Tracker Config"
  end
end
