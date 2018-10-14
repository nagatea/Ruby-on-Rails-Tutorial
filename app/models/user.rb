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
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.created_desc.where("microposts.user_id IN (#{following_ids}) OR microposts.user_id = :user_id", user_id: id).joins("LEFT JOIN favorite_relationships ON microposts.id = favorite_relationships.micropost_id").group("microposts.id").select("microposts.*, COUNT(favorite_relationships.id) AS favorite_count")
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
