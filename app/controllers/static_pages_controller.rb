class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @feed_items = current_user.feed.order_by_likes.order_by_create
    else
      @feed_items = Idea.where(represented_by:nil).order_by_likes.order_by_create
    end
    @feed_items = @feed_items.page(params[:page]).per(8)
  end
  
  def help
  end

  def about
  end

  def contact
  end
end
