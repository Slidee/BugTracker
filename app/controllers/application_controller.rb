class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def check_authentication
    deny_access unless signed_in?
  end

  def check_is_admin
    restrict_access unless signed_in? && current_user.admin?
  end
end
