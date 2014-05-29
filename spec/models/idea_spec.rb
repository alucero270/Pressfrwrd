require 'spec_helper'

describe Idea do

  let(:user) { FactoryGirl.create(:user) }
  before { @idea = user.ideas.build(content: "Lorem ipsum") }

  subject { @idea }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }

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
end
