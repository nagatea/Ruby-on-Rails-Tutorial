class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy following followers)
  before_action :correct_user,   only: %i(edit update)
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    microposts = Micropost.arel_table
    favorite_relationships = FavoriteRelationship.arel_table
    query = microposts.project(microposts[Arel.star], favorite_relationships[:id].count.as('favorite_count'))
              .outer_join(favorite_relationships).on(microposts[:id].eq(favorite_relationships[:micropost_id]))
              .where(microposts[:user_id].eq(@user.id))
              .group(microposts[:id])
              .order(microposts[:created_at].desc)
    @microposts = Micropost.paginate_by_sql(query.to_sql, page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @follow_users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @follow_users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def favorites
    @title = "Favorites"
    @user = User.find(params[:id])
    microposts = Micropost.arel_table
    favorite_relationships = FavoriteRelationship.arel_table
    query = microposts.project(microposts[Arel.star], favorite_relationships[:id].count.as('favorite_count'))
              .outer_join(favorite_relationships).on(microposts[:id].eq(favorite_relationships[:micropost_id]))
              .where(favorite_relationships[:user_id].eq(@user.id))
              .group(microposts[:id])
              .order(microposts[:created_at].desc)
    @feed_items = Micropost.paginate_by_sql(query.to_sql, page: params[:page])
    render 'show_favorite'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
