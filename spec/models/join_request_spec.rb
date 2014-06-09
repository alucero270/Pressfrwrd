require 'spec_helper'
describe JoinRequest do
  subject { FactoryGirl::create(:join_request) }
  it { should respond_to(:idea) }
  it { should respond_to(:group) }

  describe "accept!" do
    before do
      @idea_to_join = FactoryGirl::create(:idea)
      @group = @idea_to_join.group
      @idea = FactoryGirl::create(:idea)
      @join_request = JoinRequest.create(idea:@idea,group:@group)
    end

    it "should add idea to group" do
      @join_request.accept!
      expect(@group.ideas).to match_array([@idea,@idea_to_join])
      expect(Group.find(@group.id).ideas).to match_array([@idea,@idea_to_join])
    end
    
    it "should change request status to accepted" do
      expect(@join_request).to be_pending
      @join_request.accept!
      expect(@join_request).to be_accepted
    end
  end

  describe "votes" do
    before do
      @idea_to_join = FactoryGirl::create(:idea)
      @group = @idea_to_join.group
      @idea = FactoryGirl::create(:idea)
    end

    it "should create votes" do
      @join_request = JoinRequest.create(idea:@idea,group:@group)
      expect(@join_request.votes.size).to eq(@group.ideas.size)
      expect(@join_request.votes.map {|v| v.user }).to match_array(@group.users)
    end
    
    it "should create votes when a new group is added" do
      @join_request = JoinRequest.create(idea:@idea,group:@group)
      expect(@join_request.votes.map {|v| v.user }).to match_array(@group.users)
      @idea2 = FactoryGirl::create(:idea)
      @join_request2 = JoinRequest.create(idea:@idea,group:@group)
      @join_request2.accept!
      expect(@join_request.reload.votes.size).to equal(@group.ideas.size)
      expect(@join_request.votes.map {|v| v.user }).to match_array(@group.reload.users)
    end
    
    it "should reject/accept idea when majority reached" do
      @join_request = JoinRequest.create(idea:@idea,group:@group)
      @vote = @join_request.votes.find_by(user:@group.ideas.first.user)
      expect(@join_request.pending?).to be_true
      expect(@join_request.accepted?).to be_false
      @vote.accepted!
      expect(@join_request.reload.accepted?).to be_true
      expect(@join_request.reload.pending?).to be_false
    end

    it "should join a group when accepted" do
      @join_request = JoinRequest.create(idea:@idea,group:@group)
      @vote = @join_request.votes.find_by(user:@group.ideas.first.user)
      @vote.accepted!
      expect(@join_request.reload.group.ideas).to include(@idea)
    end
  end
end