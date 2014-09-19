class Idea < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :assets, dependent: :destroy

  has_many :votes

  has_many :join_requests
  has_many :join_to_me_requests, class_name: 'JoinRequest', foreign_key: :to_idea_id

  belongs_to :represented_by, class_name: 'Idea', inverse_of: :representing
  has_many :representing, class_name: 'Idea', inverse_of: :represented_by, foreign_key: :represented_by_id

  belongs_to :merged_to, class_name: 'Idea'
  belongs_to :merged_into, class_name: 'Idea'

  default_scope { order(created_at: :desc) }
  
  validates :content, presence: true, length: { maximum: 1400 }
  validates :user_id, presence: true

  before_save :add_hashtags_to_tags
  after_update :save_assets

  has_many :likes

  def self.create_with_merge!(merge_to,merged)
    ret = self.create!(title:merge_to.title,content:(merge_to.content||"")+"\r\n>>>MERGE:\r\n"+(merged.title||"")+"\r\n"+(merged.content||""),user:merge_to.user)
    merge_to.assets.each do |asset|
      ret.assets.create! file:asset.file
    end
    merged.assets.each do |asset|
      ret.assets.create! file:asset.file
    end
    ret
  end

  def self.order_by_likes
    reorder(likes_sum_cache: :desc)
  end

  def self.order_by_create
    order(created_at: :desc)
  end

  def self.active
    where(represented_by:nil)
  end

  def self.unmerged
    where(merged_to_id:nil)
  end

  def self.users
    User.where(id:reorder('').uniq(:user_id).pluck(:user_id))
  end

  def representing_and_self
    Idea.where('ideas.represented_by_id = ? or id = ?',self.id,self.id)
  end

  def similiar
    Idea.active.where.not(id:self.id).text_search(self.content)
  end

  def editable?
    represented_by.blank?
  end

  def editable_by?(user)
    user.present? && representing_and_self.users.include?(user)
  end

  # non superseeding
  # where(represented_by:nil or )

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
    followed_user_ids = user.followed_user_ids_or_self
    joins('LEFT OUTER JOIN ideas i2 ON i2.represented_by_id = ideas.id').
    where('(ideas.represented_by_id is NULL and ideas.user_id in (?)) OR (i2.user_id in (?))',followed_user_ids,followed_user_ids).distinct(:id)
  end
  
  include PgSearch
  pg_search_scope :search, against: [:content],
    using: {tsearch: {dictionary: "english", any_word: true}}
  
  def self.text_search(query)
    if query.present?
      unscope(:order).search(query)
    else
      all
    end
  end

  def update_likes_sum_cache
    self.update(likes_sum_cache: self.likes.sum(:value).to_i)
  end

  private

  def do_create_group
    ret = self.create_group!(idea:self)
    self.save!
    ret
  end
end
