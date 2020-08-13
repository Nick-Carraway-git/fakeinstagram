class MicropostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user,   only: :destroy

  def show
    # 返信用フォームに渡す空オブジェクト
    @for_reply_micropost = Micropost.new
    @micropost = Micropost.find_by(id: params[:id])
    @reply_microposts = Micropost.where("in_reply_to = ?", params[:id])
    # 指定されたmicropostがnilでないなら、返信元へリダイレクト
    if !(@micropost.nil?) && !(@micropost.in_reply_to.nil?)
      @micropost = Micropost.find_by(id: @micropost.in_reply_to)
      redirect_to micropost_path(@micropost)
    end
  end

  def new
    @micropost = Micropost.new
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
      if @micropost.save
        # 投稿が返信かどうかで条件分岐 / 返信の場合は①コメント通知の作成、②当該マイクロポストへのリダイレクト
        if !(@micropost.in_reply_to.nil?)
          if @micropost.user != current_user
            # replyされたMicropostを検索して、これに対して通知を作成
            replyMicropost = Micropost.find_by(id: @micropost.in_reply_to)
            replyMicropost.create_notification_reply!(current_user, @micropost.id)
          end
          flash[:success] = "投稿に返信しました。"
          # redirect_to micropost_path(@micropost)
          # モーダルを閉じるためのjs
          respond_to do |format|
            format.html
            format.js
          end
        else
          flash[:success] = "投稿に成功しました！"
          redirect_to micropost_path(@micropost)
        end
      else
        render 'microposts/new'
      end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end


    private

      def micropost_params
        params.require(:micropost).permit(:content, :in_reply_to)
      end

      # Micropostのuser_idとcurrent_userのidが同じか確認
      def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
      end
end
