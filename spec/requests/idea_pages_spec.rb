require 'spec_helper'

describe "Idea pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "idea creation" do
    before { visit root_path }
    
    describe "with invalid information" do
      
      it "should not create a idea" do
        expect { click_button "Post" }.not_to change(Idea, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'idea_content', with: "Lorem ipsum" }
      it "should create a idea" do
        expect { click_button "Post" }.to change(Idea, :count).by(1)
      end
    end
  end

  describe "idea destruction" do
    before { FactoryGirl.create(:idea, user: user) }
    
    describe "as correct user" do
      before { visit root_path }
      
      it "should delete a idea" do
        expect { click_link "delete" }.to change(Idea, :count).by(-1)
      end
    end
  end
end