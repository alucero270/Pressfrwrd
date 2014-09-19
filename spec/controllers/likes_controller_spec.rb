require 'spec_helper'

describe LikesController do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    sign_in user, no_capybara: true 
    request.env["HTTP_REFERER"] = "came_from_url"
  end

  describe "POST#create" do
    let(:idea) { create(:idea, user_id: user.id) }
    before { post :create, idea_id: idea.id, value:+1 }
    it "creates like" do
      expect(idea.likes.pluck(:value)).to eq([1])
    end
  end
  
end