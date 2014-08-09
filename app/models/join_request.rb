# JoinRequest is a request to join to ideas. 
# When ideas are actually joined, we need to migrate and extend non accepted
# join requests to the ideas involved.
class JoinRequest < ActiveRecord::Base
  belongs_to :group
  belongs_to :idea
  belongs_to :to_idea, class_name: 'Idea', inverse_of: :join_to_me_requests
  belongs_to :merged_into, class_name: 'Idea'

  has_many :votes

  after_create :create_votes

  validates :to_idea, presence: true
  validates :idea, presence: true
  validates_uniqueness_of :idea_id, scope: :to_idea_id, message: "has already a join request to this idea"
  
  scope :not_accepted, ->{ where.not(status: JoinRequest.statuses[:accepted]) }

  def accept!
    new_idea = Idea.create_with_merge!(to_idea,idea)
    self.update!(status: :accepted,merged_into_id:new_idea.id)
    to_idea.update!(represented_by:new_idea,merged_into_id:new_idea.id)
    idea.update!(represented_by:new_idea,merged_to_id:to_idea.id,merged_into_id:new_idea.id,merged_on:DateTime.now)
    to_idea.join_to_me_requests.not_accepted.each do |request|
      request.migrate_to(new_idea)
    end
    idea.join_to_me_requests.not_accepted.each do |request|
      request.migrate_to(new_idea)
    end
    new_idea
  end

  def reject!
    self.update!(status: :rejected)
    nil
  end

  enum status: [:pending, :accepted, :rejected]

  def auto_set_status
    if votes.accepted.count > votes.count/2 then
      self.accept!
    elsif votes.rejected.count >= (votes.count+1)/2 then
      self.reject!
    else
      nil
    end
  end
  
  protected
  
  def migrate_to(new_idea)
    self.to_idea = new_idea
    self.save
  end

  private

  def create_votes
    users = Set[]
    self.to_idea.representing_and_self.users.each do |user|
      votes.create!(user:user)
    end
  end
end