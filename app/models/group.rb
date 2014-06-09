class Group < ActiveRecord::Base
  has_many :join_requests

  has_many :ideas
  has_many :users, through: :ideas

  def title
    ideas.first.title
  end
end