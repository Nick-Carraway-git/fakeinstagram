require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  # ログインしないと特定ユーザーのフォローを見れない
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to root_url
  end

  # ログインしないと特定ユーザーのフォロワーが見れない
  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to root_url
  end
end
