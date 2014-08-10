require 'spec_helper'

describe Idea do

  let(:user) { FactoryGirl.create(:user) }
  before { @idea = user.ideas.build(content: "Lorem ipsum") }

  subject { @idea }

  it { should respond_to(:content) }
  it { should respond_to(:user) }
  it { should respond_to(:represented_by) }
  it { should respond_to(:representing) }
  
  describe "validation" do
    context "when user_id is not present" do
      before { @idea.user_id = nil }
      it { should_not be_valid }
    end
    
    context "with blank content" do
      before { @idea.content = " " }
      it { should_not be_valid }
    end
  
    context "with content that is too long" do
      before { @idea.content = "a" * 1401 }
      it { should_not be_valid }
    end
  end
  
  describe "representing" do
    before do
      @idea = create(:idea)
      @idea2 = create(:idea,represented_by:@idea)
      @idea3 = create(:idea,represented_by:@idea)
    end
    
    context "representing" do
      subject { @idea.representing }
      it { is_expected.to match_array([@idea2,@idea3]) }
    end
    
    context "rendersenting_and_self" do
      subject { @idea.representing_and_self }
      it { is_expected.to match_array([@idea,@idea2,@idea3]) }
    end
  end

  describe "create_with_merge" do
    before do
      @merge_to = create(:idea,title:'merge_to_title',content:'merge_to_body',user:create(:user),assets:create_list(:asset,3))
      @merged = create(:idea,title:'merged_title',content:'merged_body',user:create(:user),assets:create_list(:asset,2))
    end
    subject { Idea.create_with_merge!(@merge_to,@merged) }
    it "should merge two ideas" do
      expect(subject.title).to eq(@merge_to.title)
      expect(subject.content).to include(@merge_to.content,@merged.content,@merged.title)
      expect(subject.assets.count).to eq(@merge_to.assets.count+@merged.assets.count)
    end
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
end
