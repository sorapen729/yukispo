class ApplicationController < ActionController::Base
  include MetaTags::ControllerHelper
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_default_meta

  add_flash_types :success, :danger

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name ])
  end

  # ルート検索の出発地パラメータ
  def address_params
    params.require(:origin_address).permit(:address, :lat, :lng)
  end

  # === meta-tags のデフォルト設定（追加）===
  def set_default_meta
    # 1) OGP用のデフォルト画像URL（assetsから絶対URLを生成）
    ogp_image_url = view_context.image_url("ogp.png")

    # 2) meta-tags のデフォルト一式
    set_meta_tags(
      site:        "ゆきスポ❄️",
      title:       "スキー場検索アプリ",
      reverse:     true,                    # <title>「ページ | サイト名」形式
      separator:   " | ",
      description: "スキー場までの最適ルートを検索できるアプリ。ゆきスポ❄️",
      canonical:   request.original_url,
      noindex:     false,
      og: {
        title:     :title,
        site_name: "ゆきスポ❄️",
        type:      "website",
        url:       request.original_url,
        image:     ogp_image_url
      },
      twitter: {
        card:  "summary_large_image",
        # site は未設定なら出さない（設定あるなら ENV で）
        site:  ENV["TWITTER_SITE"],
        image: ogp_image_url
      }
    )
  end
end
