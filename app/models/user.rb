class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :favorite_relationships, dependent: :destroy
  has_many :favorite_microposts, through: :favorite_relationships, source: :micropost

  before_save { email.downcase! }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum:255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def feed
    relationships = Relationship.arel_table
    microposts = Micropost.arel_table
    favorite_relationships = FavoriteRelationship.arel_table
    fav = FavoriteRelationship.arel_table.alias('fav')
    users = User.arel_table
    follower = relationships.project(relationships[:followed_id]).where(relationships[:follower_id].eq(id))
    microposts.project(microposts[Arel.star], favorite_relationships[:id].count.as('favorite_count'), users[:name].as('user_name'), users[:email].as('user_email'), users[:admin].as('user_admin'))
      .where(microposts[:user_id].in(follower).or(microposts[:user_id].eq(id)))
      .outer_join(favorite_relationships).on(microposts[:id].eq(favorite_relationships[:micropost_id]))
      .join(users).on(microposts[:user_id].eq(users[:id]))
      .group(microposts[:id])
      .order(microposts[:created_at].desc)
  end

  def feed_is_favorite
    relationships = Relationship.arel_table
    microposts = Micropost.arel_table
    favorite_relationships = FavoriteRelationship.arel_table
    follower = relationships.project(relationships[:followed_id]).where(relationships[:follower_id].eq(id))
    microposts.project(microposts[:id], favorite_relationships[:id].count.as('is_favorite'))
      .where(microposts[:user_id].in(follower).or(microposts[:user_id].eq(id)))
      .outer_join(favorite_relationships).on(favorite_relationships[:user_id].eq(id).and(favorite_relationships[:micropost_id].eq(microposts[:id])))
      .group(microposts[:id])
      .order(microposts[:created_at].desc)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def followed_by?(other_user)
    followers.include?(other_user)
  end

  def favorite(micropost)
    favorite_microposts << micropost
  end

  def unfavorite(micropost)
    favorite_relationships.find_by(micropost_id: micropost.id).destroy
  end

  def favorite?(micropost)
    favorite_microposts.include?(micropost)
  end
end
