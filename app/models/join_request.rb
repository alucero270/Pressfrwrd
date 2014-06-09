class JoinRequest < ActiveRecord::Base
  belongs_to :group
  belongs_to :idea
  has_many :users, through: {group: :ideas}
  has_many :votes

  after_create :create_votes

  validates :group, presence: true
  validates :idea, presence: true

  def accept!
    self.update_attribute(:status,:accepted)
    group.ideas << idea
    group_extended(group)
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
    self.group.users.each do |user|
      votes.create!(user:user)
    end
  end
end