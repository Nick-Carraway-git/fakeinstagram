require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
  @micropost = microposts(:one)
end

  # ログインしていない場合にはMicropostを投稿できない
  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to root_path
  end

  # ログインしていない場合にはMicropostを削除できない
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_path
  end

  # 異なる投稿者のMicropostは削除できない
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:two)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_path
  end
end
