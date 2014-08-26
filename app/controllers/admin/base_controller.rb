module Admin
  class BaseController < ApplicationController
    before_action :signed_in_user
    before_action :admins_only

    private

    def admins_only
      unless current_user.is_admin?
        redirect_to root_path
        flash.alert = "You're not authorized to view this page"
      end
    end
  end
end