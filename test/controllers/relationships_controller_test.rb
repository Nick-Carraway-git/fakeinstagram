require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  #ログインユーザーのみフォローが可能
  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to root_url
  end

  #ログインユーザーのみフォロー解除が可能
  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to root_url
  end
end
