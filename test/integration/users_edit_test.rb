require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "invalid signup information" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_no_difference 'User.count' do
      patch user_path, params: { user: { 
        name:  "", 
        email: "user@invalid", 
        password: "foo", 
        password_confirmation: "bar" } }
    end
    assert_template 'users/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "successful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path, params: { user: { 
        name:  name, 
        email: email, 
        password: "", 
        password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
