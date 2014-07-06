require 'spec_helper'

describe Idea do

  let(:user) { FactoryGirl.create(:user) }
  before { @idea = user.ideas.build(content: "Lorem ipsum") }

  subject { @idea }

  it { should respond_to(:content) }
  it { should respond_to(:user) }
  it { should respond_to(:group) }
  it { should respond_to(:has_group?) }
  it { should respond_to(:is_in_group?) }

  describe "when user_id is not present" do
    before { @idea.user_id = nil }
    it { should_not be_valid }
  end
    
  describe "with blank content" do
    before { @idea.content = " " }
    it { should_not be_valid }
  end
  
  describe "with content that is too long" do
    before { @idea.content = "a" * 1401 }
    it { should_not be_valid }
  end

  describe "hashtags" do
    context "when saving with hashtag in context" do
      before do
        @idea.content ="#foo #bar #baz"
        @idea.save
      end
      it { expect(@idea.tags.pluck(:name)).to eq(["foo","bar","baz"])}
    end
  end

  describe "group" do
    it "should be non empty" do
      expect(@idea.group).not_to be_nil
    end

    it "should be the same" do
      group_1st = @idea.group
      group_2nd = @idea.group
      expect(group_1st.id).to eq(group_2nd.id)
      expect(group_1st.ideas).to eq([@idea])
    end

    it "is created lazily" do
      @idea.save!
      expect(Idea.where(id:@idea.id,group_id:nil)).to eq([@idea])
      @idea.group
      expect(Idea.where(id:@idea.id,group_id:nil)).to eq([])
    end
  end
end
