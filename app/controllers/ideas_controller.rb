class IdeasController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @idea  = current_user.ideas.build
  end

  def index
    if params[:query]
      ideas = Idea.text_search(params[:query])
    elsif params[:tag]
      ideas = Idea.tagged_with(params[:tag])
    else
      ideas = Idea
    end
    @ideas = ideas.page(params[:page]).per(8)
  end

  def show
    @idea = Idea.find(params[:id])
  end

  def edit
    @idea = Idea.find(params[:id])
    raise ActiveRecord::RecordNotFound.new("Idea #{params[:id]} is not editable by this user") unless @idea.editable_by?(current_user)
    if !@idea.editable?
      flash.alert = "This idea was merged to another one, redirected to the idea it was merged to"
      return redirect_to edit_idea_path(@idea.represented_by)
    end
  end

  def update
    @idea = current_user.ideas.find(params[:id])
    if @idea.update(idea_params)
      flash[:success] = "Idea updated!"
      return redirect_to similiar_idea_path(@idea)
    else
      flash.alert = "Unable to save idea"
      return render :edit
    end
  end

  def create
    @idea = current_user.ideas.build(idea_params)
    if @idea.save
      flash[:success] = "Idea created!"
      return redirect_to similiar_idea_path(@idea)
    else
      flash.alert = "Unable to save idea"
      return render :new
    end
  end
  
  def similiar
    @idea = Idea.find(params[:id])
    @similiar_ideas = @idea.similiar.page(params[:page]).per(3)
  end

  def join
  end

  def destroy
    @idea.destroy
    redirect_to root_url
  end

  private

    def idea_params
      params.require(:idea).permit(:content, :tag_list, :title, {new_asset_attributes:[:file,:filename],existing_asset_attributes:[:file,:filename,:_destroy]})
    end
  
    def correct_user
      @idea = current_user.ideas.find_by(id: params[:id])
      redirect_to root_url if @idea.nil?
    end
end
