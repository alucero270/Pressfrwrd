class LikesController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]

  def create
    load_idea

    @idea.likes.create!(user:current_user, value:params.require(:value))
    redirect_to :back
  end

  private

  def load_idea
    @idea = current_user.ideas.find(params.require(:idea_id))
  end
end