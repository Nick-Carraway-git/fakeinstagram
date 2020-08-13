module NotificationsHelper
  def notification_form(notification)
     # visitor_idを外部キーとしてユーザー情報を取得
     @visitor = notification.visitor
     @reply = nil
     your_micropost = link_to 'あなたの投稿', micropost_path(notification), style:"font-weight: bold;"
     @visitor_reply = notification.reply_id
     #notification.actionがfollowかfavoriteかreplyか
     case notification.activity
     when "follow" then
         tag.a(notification.visitor.name, href:user_path(@visitor), style:"font-weight: bold;")+"があなたをフォローしました"
       when "favorite" then
         tag.a(notification.visitor.name, href:user_path(@visitor), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:micropost_path(notification.micropost_id), style:"font-weight: bold;")+"にいいねしました"
       when "reply" then
           @reply = Micropost.find_by(id: @visitor_reply)&.content
           tag.a(@visitor.name, href:user_path(@visitor), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:micropost_path(notification.micropost_id), style:"font-weight: bold;")+"にコメントしました"
     end
   end

   def unchecked_notifications
     @notifications = current_user.passive_notifications.where(checked: false)
   end
end
