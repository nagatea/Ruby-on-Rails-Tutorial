class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      user_res = @user.attributes
      user_res.delete('password_digest')
      @micropost = current_user.microposts.build
      @feed_items = Micropost.paginate_by_sql(@user.feed.to_sql, page: params[:page])
      items_res = []
      @feed_items.each do |item|
        favorite_relationships = item.favorite_relationships.find_by(user_id: @user.id)
        if favorite_relationships
          favorite_relationships_id = favorite_relationships.id
        else
          favorite_relationships_id = nil
        end
        item_hash = item.attributes
        item_hash["favorite_relationships_id"] = favorite_relationships_id
        items_res << item_hash
      end

      res = {
        currentUser: user_res,
        micropostCount: @user.microposts.count,
        followingCount: @user.following.count,
        followersCount: @user.followers.count,
        favoritesCount: @user.favorite_microposts.count,
        feedItems: items_res
      }.to_json
    end
    respond_to do |format|
      format.html
      format.json { render :json => res }
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
