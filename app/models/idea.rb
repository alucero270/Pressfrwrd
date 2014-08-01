class Idea < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :assets, dependent: :destroy

  has_many :votes

  has_many :join_requests
  has_many :join_to_me_requests, class: 'JoinRequest', inverse_of: :to_idea
  
  belongs_to :represented_by, class_name: 'Idea', inverse_of: :representing
  has_many :representing, class_name: 'Idea', inverse_of: :represented_by, foreign_key: :represented_by_id
  
  belongs_to :merged_to, class_name: 'Idea'

  default_scope { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 1400 }
  validates :user_id, presence: true

  before_save :add_hashtags_to_tags
  after_update :save_assets

  def self.create_with_merge!(merge_to,merged)
    self.create!(title:merge_to.title,content:(merged.content||"")+"\n\n>>>MERGE:\n"+(merged.title||"")+"\n"+(merged.content||""),user:merge_to.user)
  end
  
  def self.unmerged
    where(merged_to_id:nil)
  end
  
  def representing_and_self
    Idea.where('ideas.represented_by_id = ? or id = ?',self.id,self.id)
  end
  
  def self.users
    User.where(id:reorder('').uniq(:user_id).pluck(:user_id))
  end

  def new_asset_attributes=(asset_attributes)
    asset_attributes.each do |attributes|
      assets.build(attributes)
    end
  end

  def existing_asset_attributes=(asset_attributes)
    assets.reject(&:new_record?).each do |asset|
      attributes = asset_attributes[asset.id.to_s]
      if attributes 
        if attributes['_destroy']=='true'
          asset.delete
        else
          asset.attributes = attributes.except('_destroy')
        end
      end
    end
  end

  def save_assets
    assets.each do |asset|
      asset.save(validate:false)
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

  def join_to_me_requests
    self.join_to_requests
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
    ret = self.create_group!(idea:self)
    self.save!
    ret
  end
end
