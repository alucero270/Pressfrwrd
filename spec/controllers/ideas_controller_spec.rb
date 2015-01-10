require 'spec_helper'

describe IdeasController do
  render_views

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user, no_capybara: true }

  describe "GET#index" do
    subject { get :index }
    it { is_expected.to render_template("index") }

    context "with ideas" do
      let!(:ideas) { (1..3).map do |i|
        create(:idea,title:"idea_#{i}")
      end }
      it "renders ideas" do
        is_expected.to render_template("index")
        expect(response.body).to have_css('h3.idea-title',text:ideas.first.title)
      end

      context "when liked" do
        let!(:like_p) { create(:like, idea:ideas.first, user: user, value: +1) }
        let!(:like_m) { create(:like, idea:ideas.second, user: user, value: -1) }
        it "renders like as selected" do
          is_expected.to render_template("index")
          expect(response.body).to have_css("a.like-button.selected[href='#{like_path(like_p)}']")
          expect(response.body).to have_css("a.unlike-button.selected[href='#{like_path(like_m)}']")
          expect(response.body).to have_css("a.like-button.selected",count:1)
          expect(response.body).to have_css("a.unlike-button.selected",count:1)
          expect(response.body).to have_css("a.like-button",count:3)
          expect(response.body).to have_css("a.unlike-button",count:3)
        end
      end
    end
  end

  describe "GET#index mine" do
    subject { get :index, mine: true }
    it { is_expected.to render_template("index") }
  end

  describe "GET#edit" do
    let(:idea) { create(:idea, user_id: user.id) }
    subject { get :edit, id: idea.id }
    it { is_expected.to render_template("edit") }
  end

  describe "PUT#update" do
    let(:idea) { create(:idea, user_id: user.id) }
    before { put :update, id: idea.id, idea: {title: "Foo this is the new title"} }
    it "modifies title" do
      expect(idea.reload.title).to eq("Foo this is the new title")
    end
  end
  
end