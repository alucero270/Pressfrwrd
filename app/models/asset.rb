class Asset < ActiveRecord::Base
  belongs_to :idea
  
  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment :file, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
end