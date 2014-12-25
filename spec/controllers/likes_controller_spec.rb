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

    subject { post :create, idea_id: idea.id, value:+1 }

    it "creates like" do
      subject
      expect(idea.likes.pluck(:value)).to eq([1])
    end

    context "on other users idea" do
      let(:idea) { create(:idea, user_id: other_user.id) }

      it "can create like" do
        subject
        expect(idea.likes.pluck(:value)).to eq([1])
      end
    end
  end

end