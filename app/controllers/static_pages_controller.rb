class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @feed_items = current_user.feed.page(params[:page]).per(8)
    else
      @feed_items = Idea.all
    end
  end
  
  def help
  end

  def about
  end

  def contact
  end
end
