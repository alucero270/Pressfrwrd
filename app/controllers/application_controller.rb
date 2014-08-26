class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  include SessionsHelper

  private

  def record_not_found
    flash.alert = 'This data does not exists or you do not have rights for it'
    redirect_to(root_path)
  end
end
