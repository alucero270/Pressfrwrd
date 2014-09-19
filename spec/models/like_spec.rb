require 'spec_helper'

describe Like do
  subject { create(:like, value:+1) }

  it { is_expected.to respond_to(:value) }
  it { is_expected.to respond_to(:idea) }
  it { is_expected.to respond_to(:user) }

  describe "multiple votes" do
    subject { create(:like, idea:create(:idea), user: create(:user), value: +1)  }

    it "doesnt allow two votes by the same user" do
      like = Like.new(idea: subject.idea, user:subject.user, value: +1)
      expect(like.valid?).to eq(false)
    end
  end

  describe "count_value" do
    subject do
      likesarr = create_list(:like, 3, value: +1)+create_list(:like, 2, value: -1)
      Like.where(id:likesarr.map(&:id))
    end

    it "should count + or - values" do 
      expect(subject.count_value(+1)).to eq(3) 
      expect(subject.count_value(-1)).to eq(2)
    end
  end

  describe "ide's likes_sum_cache" do
    let (:idea) { create(:idea) }
    it "sets cache on create" do
      create_list(:like, 3, value: +1, idea:idea)+create_list(:like, 1,value:-1, idea:idea)
      expect(idea.reload.likes_sum_cache).to eq(2)
    end
    
    it "decrements cache on destroy" do
      likes = create_list(:like, 3, value: +1, idea:idea)+create_list(:like, 1,value:-1, idea:idea)
      likes[0].destroy!
      expect(idea.reload.likes_sum_cache).to eq(1)
    end 
    
    it "zero for new idea" do
      expect(idea.likes_sum_cache).to eq(0)
    end
  end
end