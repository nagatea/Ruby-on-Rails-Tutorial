class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      @micropost = current_user.microposts.build
      @feed_items = Micropost.paginate_by_sql(@user.feed.to_sql, page: params[:page])
      res = {
        currentUser: @user,
        micropostCount: @user.microposts.count,
        followingCount: @user.following.count,
        followersCount: @user.followers.count,
        favoritesCount: @user.favorite_microposts.count,
        feedItems: @feed_items
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
