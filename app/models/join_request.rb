class JoinRequest < ActiveRecord::Base
  belongs_to :group
  belongs_to :idea
  belongs_to :to_idea, class_name: 'Idea'

  has_many :votes

  after_create :create_votes

  validates :to_idea, presence: true
  validates :idea, presence: true

  def accept!
    self.update_attribute(:status,:accepted)
    
    idea.merged_to=to_idea
    idea.merged_on=DateTime.now
    new_idea = Idea.create_with_merge!(to_idea,idea)
    to_idea.update!(represented_by:new_idea)
    idea.update!(represented_by:new_idea)
    new_idea
  end

  enum status: [:pending, :accepted, :rejected]

  def auto_set_status
    if votes.accepted.count > votes.count/2 then
      self.accept!
    end
  end

  private

  def group_extended(group)
    group.join_requests.pending.each do |req|
      if req.votes.where(user:idea.user).count == 0
        req.votes.create!(user:idea.user)
      end
    end
  end

  def create_votes
    users = Set[]
    self.to_idea.representing_and_self.users.each do |user|
      votes.create!(user:user)
    end
  end
end