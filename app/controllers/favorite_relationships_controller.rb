class FavoriteRelationshipsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @micropost = Micropost.select("microposts.*, COUNT(favorite_relationships.id) AS favorite_count").joins("LEFT JOIN favorite_relationships ON microposts.id = favorite_relationships.micropost_id").group("microposts.id").find(params[:micropost_id])
    current_user.favorite(@micropost)
    @micropost.favorite_count += 1
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def destroy
    @micropost = FavoriteRelationship.select("microposts.*, COUNT(favorite_relationships.id) AS favorite_count").joins("LEFT JOIN microposts ON microposts.id = favorite_relationships.micropost_id").group("favorite_relationships.id").find(params[:id])
    current_user.unfavorite(@micropost)
    @micropost.favorite_count -= 1
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
end
