require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', test: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    assert_select 'div.stats'
    assert_select 'strong#following'
    assert_select 'strong#followers'
  end

  test "follow_from display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'div#follow_form', false
    get user_path(@other_user)
    assert_select 'div#follow_form'
  end
end
