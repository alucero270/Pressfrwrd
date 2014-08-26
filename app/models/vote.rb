class Vote < ActiveRecord::Base
  belongs_to :join_request
  belongs_to :user

  validates :join_request, presence: true
  validates :user, presence: true

  enum status: [:pending, :accepted, :rejected]

  def rejected!
    super
    self.join_request.auto_set_status
  end

  def accepted!
    super
    self.join_request.auto_set_status
  end
end