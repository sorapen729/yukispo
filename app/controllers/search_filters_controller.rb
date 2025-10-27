class SearchFiltersController < ApplicationController
  def new
    # ログインユーザーの場合、マイページの住所を取得してセッションに保存
    if user_signed_in? && current_user.address.present?
      session[:origin_address] = {
        "address" => current_user.address
      }
    end
    # ログインしていない場合や住所が未設定の場合は、
    # セッションに既に保存されている住所を使用（住所入力画面から遷移した場合）
  end
end
