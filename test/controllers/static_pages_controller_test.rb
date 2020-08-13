require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @micropost = microposts(:one)
  end

  test "should get home" do
    get root_url
    assert_response :success
  end

  test "should get help" do
    get help_path
    assert_response :success
  end

  test "should get about" do
    get about_path
    assert_response :success
  end

  test "should get rule" do
    get rules_path
    assert_response :success
  end

  test "should get result" do
    get results_path
    assert_response :success
  end
end
