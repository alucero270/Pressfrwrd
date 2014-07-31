require 'spec_helper'

describe IdeasController do

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user, no_capybara: true }

  describe "get#INDEX" do
    subject { get :index }
    it { is_expected.to render_template("index") }
  end
  
  describe "get#INDEX" do
    let(:idea) { create(:idea, user_id: user.id) }
    subject { get :edit, id: idea.id }
    it { is_expected.to render_template("edit") }
  end
  
end