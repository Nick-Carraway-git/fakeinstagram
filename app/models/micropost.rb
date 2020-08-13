class Micropost < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: { message: "を入力して下さい。"}, length: { maximum: 2200 }
  validates :image,   content_type: { in: %w[image/jpeg image/png],
                                      message: "「.jpg」か「.png」のファイルを選択してください。" },
                      size:         { less_than: 5.megabytes,
                                      message: "5MBを超えるファイルはアップロードできません。" },
                      presence: { message: "を選択して下さい。"}, if: :new_micropost?


  # ログインユーザーのIDをvisitor_idとして、Notificationインスタンス(いいね)を生成し、データベースに格納
  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      micropost_id: self.id,
      visited_id: self.user_id,
      activity: "favorite"
    )
    notification.save if notification.valid?
  end

  def create_notification_reply!(current_user, reply_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Micropost.select(:user_id).where(in_reply_to: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_reply!(current_user, reply_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_reply!(current_user, reply_id, user_id) if temp_ids.blank?
  end

  def save_notification_reply!(current_user, reply_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      micropost_id: self.id,
      reply_id: reply_id,
      visited_id: visited_id,
      activity: "reply"
    )
  # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
      notification.save if notification.valid?
  end

  #micropostが返信かどうかを確認
  def new_micropost?
    self.in_reply_to == nil
  end
end
