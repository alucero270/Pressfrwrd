class JoinRequestsController < ApplicationController
  before_action :find_join_request, only: [:show,:reject,:accept]

  def create
    idea = current_user.ideas.find_by(id:params[:idea])
    idea_to_join = Idea.find_by(id:params[:idea_to_join])
    join_request = JoinRequest.new(idea:idea, to_idea:idea_to_join)
    if join_request.save!
      flash.notice = "Join requests sent"
      redirect_to :back
    else
      flash.alert = "Unable to create join request !"
      redirect_to :back
    end
  end

  def show
    prepare_for_show
  end

  def reject
    @join_request.votes.find_by(user:current_user).rejected!
    prepare_for_show
    flash.notice = "Thanks for your vote"
    render :show
  end

  def accept
    @merged_idea = @join_request.votes.find_by(user:current_user).accepted!
    if @merged_idea
      flash.notice = "Thanks for your vote, the request is now accepted, you can now edit the merged idea."
      return redirect_to(edit_idea_path(@merged_idea)) if @merged_idea
    else
      flash.notice = "Thanks for your vote"
    end
    prepare_for_show
    render :show
  end

  private

  def prepare_for_show
    @current_users_vote = @join_request.votes.find_by(user:current_user)
    @merged_idea = @join_request.merged_into
  end

  def find_join_request
    @join_request = JoinRequest.find(params[:id])
  end
  
end