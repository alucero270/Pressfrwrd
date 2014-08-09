require 'spec_helper'
describe JoinRequest do
  subject { create(:join_request) }
  it { should respond_to(:idea) }
  it { should respond_to(:to_idea) }

  describe "accept!" do
    before do
      @idea_to_join = create(:idea)
      @idea = create(:idea)
      @join_request = JoinRequest.create(idea_id:@idea.id,to_idea_id:@idea_to_join.id)
    end

    it "should add idea to group" do
      @join_request.accept!
      @idea.reload ; @idea_to_join.reload
      @new_idea = @idea.represented_by
      expect(@idea.represented_by).to eq(@new_idea)
      expect(@idea_to_join.represented_by).to eq(@new_idea)
      expect(@idea.merged_to).to eq(@idea_to_join)
      expect(@idea.merged_into).to eq(@new_idea)
      expect(@idea.merged_on).to be_within(1.hours).of(DateTime.now)
      expect(@new_idea.representing).to match_array([@idea,@idea_to_join])
      expect(@join_request.merged_into).to eq(@new_idea)
    end
    
    it "should change request status to accepted" do
      expect(@join_request).to be_pending
      @join_request.accept!
      expect(@join_request).to be_accepted
    end
    
    it "should migrate existing pending join requests" do
      @user2 = create(:user)
      @idea2 = create(:idea,user:@user2)
      @join_request2 = create(:join_request,idea:@idea2,to_idea:@idea_to_join)
      expect(@idea_to_join.join_to_me_requests).to include(@join_request,@join_request2)
      @new_idea = @join_request.accept!
      expect(@new_idea.reload.join_to_me_requests).to include(@join_request2)
    end
  end

  describe "votes" do
    before do
      @idea_to_join = create(:idea)
      @idea = create(:idea)
    end

    it "should create votes" do
      @join_request = JoinRequest.create(idea:@idea,to_idea:@idea_to_join)
      expect(@join_request.votes.size).to eq(@idea_to_join.representing_and_self.size)
      expect(@join_request.votes.map {|v| v.user }).to match_array(@idea_to_join.representing_and_self.users)
    end
    
    it "should create votes when a join request is accepted to another" do
      @join_request = JoinRequest.create!(idea:@idea,to_idea:@idea_to_join)
      expect(@join_request.votes.map {|v| v.user }).to match_array(@idea_to_join.representing_and_self.users)
      @idea2 = FactoryGirl::create(:idea)
      @join_request2 = JoinRequest.create!(idea:@idea2,to_idea:@idea_to_join)
      @join_request2.accept!
      expect(@join_request.reload.votes.size).to equal(@idea_to_join.representing_and_self.size)
      expect(@join_request.votes.map {|v| v.user }).to match_array(@idea_to_join.reload.representing_and_self.users)
    end
    
    it "should accept idea when majority reached" do
      @join_request = JoinRequest.create(idea:@idea,to_idea:@idea_to_join)
      @vote = @join_request.votes.find_by(user:@idea_to_join.representing_and_self.first.user)
      expect(@join_request.pending?).to be_truthy
      expect(@join_request.accepted?).to be_falsey
      @vote.accepted!
      expect(@join_request.reload.accepted?).to be_truthy
      expect(@join_request.reload.pending?).to be_falsey
    end

    it "should reject idea when majority reached" do
      @join_request = JoinRequest.create(idea:@idea,to_idea:@idea_to_join)
      @vote = @join_request.votes.find_by(user:@idea_to_join.representing_and_self.first.user)
      expect(@join_request.pending?).to be_truthy
      expect(@join_request.accepted?).to be_falsey
      @vote.rejected!
      expect(@join_request.reload.accepted?).to be_falsey
      expect(@join_request.reload.pending?).to be_falsey
      expect(@join_request.reload.rejected?).to be_truthy
    end

    it "should join a idea when accepted" do
      @join_request = JoinRequest.create(idea:@idea,to_idea:@idea_to_join)
      @vote = @join_request.votes.find_by(user:@idea_to_join.representing_and_self.first.user)
      @vote.accepted!
      expect(@join_request.reload.to_idea.represented_by.representing).to include(@idea)
    end
  end
end