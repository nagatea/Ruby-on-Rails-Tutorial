class RenameFavoriteToFavoriteRelationship < ActiveRecord::Migration[5.1]
  def change
    rename_table :favorites, :favorite_relationships
  end
end
