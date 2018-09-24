class FavoriteRelationship < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
end
