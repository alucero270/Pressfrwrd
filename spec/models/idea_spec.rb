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
