require 'spec_helper'

describe Group do
  before do
    @idea = FactoryGirl.create(:idea)
    @group = @idea.create_group!
    @idea.save!
  end

  it "should delete group when idea is deleted" do
    @idea.destroy!
    expect(Group.where(id:@group.id)).to be_blank
  end
end