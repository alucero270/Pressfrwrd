class Vote < ActiveRecord::Base
  belongs_to :join_request
  belongs_to :idea

  validates :idea, presence: true
end