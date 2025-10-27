class OriginFavoriteAddressesController < ApplicationController
  def create
    # ログインユーザーのお気に入り住所をセッションに保存
    if user_signed_in? && current_user.address.present?
      session[:origin_address] = {
        "address" => current_user.address,
        "lat" => nil,
        "lng" => nil
      }
      redirect_to new_search_filter_path
    else
      redirect_to new_origin_selection_path, alert: "お気に入り住所が設定されていません"
    end
  end
end
