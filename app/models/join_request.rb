class JoinRequest < ActiveRecord::Base
  belongs_to :group
  belongs_to :idea
  has_many :votes

  after_create :create_votes

  validates :group, presence: true
  validates :idea, presence: true

  def accept!
    self.update_attribute(:status,:accepted)
    group.ideas << idea
    group.join_requests.pending.each do |req|
      req.votes.create!(idea:idea)
    end
  end

  enum status: [:pending, :accepted, :rejected]

  private

  def create_votes
    self.group.ideas.each do |idea|
      votes.create!(idea:idea)
    end
  end
end