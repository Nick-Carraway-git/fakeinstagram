require 'test_helper'

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  #ログインユーザーのみいいねが可能
  test "create should require logged-in user" do
    assert_no_difference 'Favorite.count' do
      post favorites_path
    end
    assert_redirected_to root_url
  end

  #ログインユーザーのみいいね解除が可能
  test "destroy should require logged-in user" do
    assert_no_difference 'Favorite.count' do
      delete favorite_path(favorites(:one))
    end
    assert_redirected_to root_url
  end
end
