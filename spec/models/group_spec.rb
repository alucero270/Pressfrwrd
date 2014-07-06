require 'spec_helper'

describe Group do
  it { should respond_to(:size) }
  it { should respond_to(:ideas) }

  before do
    @idea = FactoryGirl.create(:idea)
    @group = @idea.create_group!
    @idea.save!
  end

  it "should delete group when idea is deleted" do
    @idea.destroy!
    expect(Group.where(id:@group.id)).to be_blank
  end

  describe "size" do
    it "should return the number of ideas in the group" do
      @idea = FactoryGirl.create(:idea)
      @group = @idea.create_group!
      @idea.save!

      expect(@group.size).to eq(1)

      @idea2 = FactoryGirl.create(:idea,group_id:@group.id)

      expect(@group.size).to eq(2)
    end
  end
end