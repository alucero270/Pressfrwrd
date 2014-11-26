require 'spec_helper'

describe IdeasController do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user, no_capybara: true }

  describe "GET#index" do
    subject { get :index }
    it { is_expected.to render_template("index") }
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