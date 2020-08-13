class StaticPagesController < ApplicationController
  def home
    @user = User.new
    # ログインボタンが_linkで重複しないためのチェック用
    @check = 'check'
    # 自分の投稿一覧の取得
    fids = current_user.following_ids if current_user != nil
    @home_microposts = Micropost.where(user_id: fids, in_reply_to: nil)
    # 自分がフォローしている人の一覧を10人までランダム取得
    @following_users = current_user.following.sample(10) if current_user
  end

  def help
  end

  def about
  end

  def rule
  end

  def result
    if !(params[:search].blank?)
      # #が含まれていた場合は予め取っておく。Micropostは#タグ検索しか出さない。
      if params[:search].include?('#')
        params[:search] = params[:search].delete('#')
        @microposts = Micropost.where('content like ?', "##{params[:search]}%").paginate(page: params[:page])
      else
        @users = User.where('name like ?', "%#{params[:search]}%").paginate(page: params[:page])
        @microposts = Micropost.where('content like ?', "##{params[:search]}%")
      end
    end
  end
end
