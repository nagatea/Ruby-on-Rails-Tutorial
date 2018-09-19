module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_user?(user)
    user == current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def store_location
    session[:fowarding_url] = request.original_url if request.get?
  end

  def redirect_back_or(default)
    redirect_to(session[:fowarding_url] || default)
    session.delete(:fowarding_url)
  end
end