class UsersController < ApplicationController
  before_action :authenticate_user! ,only: [:following, :followers]


  def show
    @user = User.find_by(id: params[:id])
    @microposts = Micropost.where(user_id: @user.id ,in_reply_to: nil).paginate(page: params[:page])
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  # ユーザーのステータスfeedの取得
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
end
