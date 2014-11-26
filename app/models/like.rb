class Like < ActiveRecord::Base
  after_save :update_idea_counter_cache
  after_destroy :update_idea_counter_cache

  belongs_to :idea
  belongs_to :user

  validates :idea, uniqueness: { scope: :user }
  validates :value, inclusion: { in: [1,-1] }

  def self.count_value(value)
    where(value:value).count
  end

  def update_idea_counter_cache
    idea.update_likes_sum_cache
  end
end