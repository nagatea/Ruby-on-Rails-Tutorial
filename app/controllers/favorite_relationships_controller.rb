class FavoriteRelationshipsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(@micropost)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def destroy
    @micropost = FavoriteRelationship.find(params[:id]).micropost
    current_user.unfavorite(@micropost)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end
end
