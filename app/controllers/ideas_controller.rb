class IdeasController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    if params[:query]
      ideas = Idea.text_search(params[:query])
    elsif params[:tag]
      ideas = Idea.tagged_with(params[:tag])
    else
      ideas = Idea
    end
    @ideas = ideas.page(params[:page]).per(3)
  end

  def create
    @idea = current_user.ideas.build(idea_params)
    if @idea.save
      flash[:success] = "Idea created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  
  def similiar
    @idea = Idea.find(params[:id])
    @ideas = Idea.text_search(@idea.content).page(params[:page]).per(3)
  end

  def destroy
    @idea.destroy
    redirect_to root_url
  end

  private

    def idea_params
      params.require(:idea).permit(:content, :tag_list)
    end
  
    def correct_user
      @idea = current_user.ideas.find_by(id: params[:id])
      redirect_to root_url if @idea.nil?
    end
end
