require 'spec_helper'

describe LikesController do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:idea) { create(:idea, user_id: user.id) }

  before do
    sign_in user, no_capybara: true 
    request.env["HTTP_REFERER"] = "back"
  end

  describe "DELETE#destroy" do
    let(:like_user) { user }
    let(:like) { create(:like,idea:idea,user:like_user,value:1)}
    subject { delete :destroy, id:like.id }

    it "should remove the like" do
      is_expected.to redirect_to "back"
      expect(idea.likes.where(user:like_user).count).to eq(0)
    end

    context "like belongs to other_user" do
      let(:like_user) { other_user }

      it "should not remove the like" do
        subject
        expect(idea.likes.where(user:like_user).count).to eq(1)
      end
    end
  end

  describe "POST#create" do
    subject { post :create, idea_id: idea.id, value:+1 }

    it "creates like" do
      is_expected.to redirect_to "back"
      expect(idea.likes.pluck(:value)).to eq([1])
    end

    context "on other users idea" do
      let(:idea) { create(:idea, user_id: other_user.id) }

      it "can create like" do
        is_expected.to redirect_to "back"
        expect(idea.likes.pluck(:value)).to eq([1])
      end
    end

    context "there is already a like" do
      it "should override old like" do
        orig_like = create(:like, idea_id:idea.id, user_id:user.id, value:-1)
        expect(subject).to redirect_to "back"

        expect(orig_like.reload.value).to eq(+1)
      end
    end
  end

end