class MypagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[edit update]
  
  def show
    @user = current_user
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to mypage_path, notice: 'プロフィールを更新しました'
    else
      flash.now[:alert] = 'プロフィールの更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :last_name, :first_name)
  end
end
