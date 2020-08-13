class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # relationship用
  has_many :active_relationships,  class_name: "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :favoring, through: :favorites, source: :micropost

  # Notification用
  has_many :active_notifications,  class_name: "Notification",
                                   foreign_key: "visitor_id",
                                   dependent: :destroy
  has_many :passive_notifications, class_name: "Notification",
                                   foreign_key: "visited_id",
                                   dependent: :destroy

  has_one_attached :image

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :username, presence: true, uniqueness: true, length: { maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, length: { maximum: 70 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :introduce, length: { maximum: 400 }

  # facebook登録・ログインの場合に、適切にユーザー情報を埋めるためのメソッド
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.username = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20] # ランダムなパスワードを作成
      # user.image = auth.info.image.gsub("picture","picture?type=large") if user.provider == "facebook"
    end
  end

  # 現在の投稿数を数えるメソッド(返信を覗く)
  def posted_microposts
    postedMicroposts = Micropost.where(user_id: id, in_reply_to: nil)
    postedMicroposts.count
  end

  # フォロー関係のメソッド
  # ユーザーをフォローする
  def follow(other_user)
    unless self == other_user
      following << other_user
    end
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  # いいね機能関係のメソッド
  # 投稿をいいねする
  def favor(favorite_micropost)
    favoring << favorite_micropost
  end

  # いいねを解除する
  def unfavor(favorite_micropost)
    self.favorites.find_by(micropost_id: favorite_micropost.id).destroy
  end

  # お気に入り済みならtrueを返す
  def favoring?(favorite_micropost_id)
    nowFavorite = Favorite.find_by(micropost_id: favorite_micropost_id)
    if nowFavorite != nil
      return nowFavorite[:user_id] == self.id
    end
  end

  # 通知関係のメソッド
  # フォロー時の通知
  def create_notification_follow!(current_user)
    newFollow = Notification.where("visitor_id = ? and visited_id = ? and activity = ? ",
                                    current_user.id, self.id, 'follow')
    if newFollow.blank?
      notification = current_user.active_notifications.new(
      visited_id: self.id,
      activity: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end
