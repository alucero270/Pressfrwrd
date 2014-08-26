class Group < ActiveRecord::Base
  has_many :join_requests

  belongs_to :idea # the idea representing the group
  has_many :ideas
  has_many :users, through: :ideas

  def title
    ideas.first.title
  end

  def size
    ideas.size
  end
end