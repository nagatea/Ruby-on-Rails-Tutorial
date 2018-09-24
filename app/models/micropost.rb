class Micropost < ApplicationRecord
  belongs_to :user
  has_many :favorite_relationships, class_name: "Favorite", dependent: :destroy
  has_many :favorites, through: :favorite_relationships, source: :user
  scope :created_desc, -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
