class Idea < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :assets, dependent: :destroy

  has_many :votes

  has_many :join_requests
  belongs_to :group, dependent: :destroy

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
      asset.save(validate:false)
    end
  end

  def group
    super || do_create_group
  end

  def has_group?
    self.group_id != nil
  end

  def is_in_group?
    self.group_id != nil and self.group.size > 1
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

  def join_to_me_requests
    if has_group?
      return self.group.join_requests
    else
      return []
    end
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

  private

  def do_create_group
    ret = self.create_group!
    self.save!
    ret
  end
end
