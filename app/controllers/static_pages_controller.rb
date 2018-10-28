class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user = current_user
      @micropost = current_user.microposts.build
      query = <<-SQL
        SELECT microposts.*, COUNT(favorite_relationships.id) AS 'favorite_count' FROM microposts 
        LEFT JOIN favorite_relationships ON microposts.id = favorite_relationships.micropost_id 
        WHERE microposts.user_id IN (
          SELECT followed_id FROM relationships 
          WHERE follower_id = #{@user.id}
        ) OR microposts.user_id = #{@user.id} 
        GROUP BY microposts.id 
        ORDER BY microposts.created_at DESC
      SQL
      @feed_items = Micropost.paginate_by_sql(query, page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
