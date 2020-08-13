require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase

    def setup
      @favorite = Favorite.new(user_id: users(:michael).id,
                          micropost_id: microposts(:one).id)
    end

    # フォロー関係が成立するか
    test "should be valid" do
      assert @favorite.valid?
    end

    # user_idが埋まっているか
    test "should require a user_id" do
      @favorite.user_id = nil
      assert_not @favorite.valid?
    end

    # micropost_idが埋まっているか
    test "should require a followed_id" do
      @favorite.micropost_id = nil
      assert_not @favorite.valid?
    end
end
