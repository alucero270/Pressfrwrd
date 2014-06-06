class Group < ActiveRecord::Base
  has_many :join_requests

  has_many :ideas
end