class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @microposts = current_user.favoring
  end

  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.favor(@micropost)
    # いいねした時に通知を作成
    @micropost.create_notification_by(current_user)
    respond_to do |format|
      format.html { redirect_to @micropost }
      format.js
    end
  end

  def destroy
    @micropost = Favorite.find(params[:id]).micropost
    current_user.unfavor(@micropost)
    respond_to do |format|
      format.html { redirect_to @micropost }
      format.js
    end
  end
end
