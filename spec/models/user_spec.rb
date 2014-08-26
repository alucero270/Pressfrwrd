require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:ideas) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: "foo", password_confirmation: "bar")
    end
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: "foo", password_confirmation: nil)
    end    
    it { should be_invalid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "modifing an existing user" do
    before { @user.save! ; @user = User.find(@user.id) }
    it "should be valid when not modifying password" do
      @user.admin=true
      @user.save!
    end
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "remember token" do
    before { @user.save! }
    it { expect(subject.remember_token).not_to be_blank }
  end

  describe "ideas associations" do

    before { @user.save! }
    let!(:older_idea) do
      FactoryGirl.create(:idea, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_idea) do
      FactoryGirl.create(:idea, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right ideas in the right order" do
      expect(@user.ideas.to_a).to eq [newer_idea, older_idea]
    end

    it "should destroy associated ideas" do
      ideas = @user.ideas.to_a
      expect(ideas).not_to be_empty
      @user.destroy
      expect(ideas).not_to be_empty
      ideas.each do |idea|
        expect(Idea.where(id: idea.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollowed_idea) do
        FactoryGirl.create(:idea, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.ideas.create!(content: "Lorem ipsum") }
      end

      it { expect(subject.feed).to include(newer_idea) }
      it { expect(subject.feed).to include(older_idea) }
      it { expect(subject.feed).not_to include(unfollowed_idea) }
      it do
        followed_user.ideas.each do |idea|
          expect(subject.feed).to include(idea)
        end
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    it { expect(subject.followed_users).to include(other_user) }

    describe "followed user" do
      subject { other_user }
      it { expect(subject.followers).to include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      it { expect(subject.followed_users).not_to include(other_user) }
    end
  end
end
