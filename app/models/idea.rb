class Idea < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :assets, :dependent => :destroy
  default_scope { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 1400 }
  validates :user_id, presence: true

  before_save :add_hashtags_to_tags
  after_update :save_assets

  def new_asset_attributes=(asset_attributes)
    asset_attributes.each do |attributes|
      assets.build(attributes)
    end
  end

  def existing_asset_attributes=(asset_attributes)
    assets.reject(&:new_record?).each do |asset|
      attributes = asset_attributes[asset.id.to_s]
      if attributes
        asset.attributes = attributes
      else
        asset.delete(asset)
      end
    end
  end

  def save_assets
    assets.each do |asset|
      asset.save(false)
    end
  end

  def add_hashtags_to_tags
    self.tag_list=Twitter::Extractor::extract_hashtags(self.content).join(",")
  end

  # Returns ideas from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
  
  include PgSearch
  pg_search_scope :search, against: [:content],
    using: {tsearch: {dictionary: "english", any_word: true}}
  
  def self.text_search(query)
    if query.present?
      unscoped.search(query)
    else
      all
    end
  end
end
