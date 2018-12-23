class FavoriteRelationshipsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @micropost = Micropost.select("microposts.*, COUNT(favorite_relationships.id) AS favorite_count").joins("LEFT JOIN favorite_relationships ON microposts.id = favorite_relationships.micropost_id").group("microposts.id").find(params[:micropost_id])
    id = current_user.favorite(@micropost)
    @micropost.favorite_count += 1
    res = {
      favorite_relationships_id: id
    }
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :json => res }
    end
  end

  def destroy
    unfavorite_micropost = FavoriteRelationship.find(params[:id]).micropost
    current_user.unfavorite(unfavorite_micropost)
    @micropost = Micropost.select("microposts.*, COUNT(favorite_relationships.id) AS favorite_count").joins("LEFT JOIN favorite_relationships ON microposts.id = favorite_relationships.micropost_id").group("microposts.id").where("microposts.id = ?", unfavorite_micropost.id).first
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
end
