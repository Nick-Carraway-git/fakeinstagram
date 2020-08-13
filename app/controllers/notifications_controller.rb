class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # current_userへの通知一覧の取得
    @notifications = current_user.passive_notifications
    # 読んだ通知はcheckedに変更
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
    @notifications = @notifications.paginate(page: params[:page])
  end

  def destroy_all
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notifications_path
  end
end
