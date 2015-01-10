class LikesController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def create
    load_idea

    @like = @idea.likes.find_or_initialize_by(user:current_user)
    @like.value = params.require(:value)
    @like.save!
    redirect_to :back
  end

  def destroy
    load_like

    @like.destroy!
    redirect_to :back
  end

  private

  def load_like
    @like = current_user.likes.find(params.require(:id))
  end

  def load_idea
    @idea = Idea.find(params.require(:idea_id))
  end
end