class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      user_res = @user.attributes
      user_res.delete('password_digest')
      @micropost = current_user.microposts.build
      @feed_items = Micropost.paginate_by_sql(@user.feed.to_sql, page: params[:page])
      favorite_items = Micropost.paginate_by_sql(@user.feed_is_favorite.to_sql, page: params[:page])
      items = @feed_items + favorite_items
      items_res = items.group_by { |item| item['id'] }.values.map{ |item| item[0].attributes.merge(item[1].attributes)}

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
      format.json { render :json => res } if params[:req] == 'ajax'
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
