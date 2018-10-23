class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      @micropost = current_user.microposts.build
      @feed_items = Micropost.paginate_by_sql(current_user.feed, page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
