module Admin
  class BaseController < ApplicationController
    before_action :authorize_admin
    
    def authorize_admin
      unless current_user.is_admin?
        redirect_to root_path
        flash.alert = "You're not authorized to view this page"
      end
    end
  end
end