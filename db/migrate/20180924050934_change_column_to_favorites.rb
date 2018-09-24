class ChangeColumnToFavorites < ActiveRecord::Migration[5.1]
  def change
    change_column :favorites, :user_id, :integer, null: false
    change_column :favorites, :micropost_id, :integer, null: false
  end
end
