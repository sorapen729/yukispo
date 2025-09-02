Rails.application.routes.draw do
  devise_for :users
  get "tops/index"
  get "posts/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # 既存
  # root "posts#index"

  # 新しくTOPページをルートに設定
  root "tops#index"

  # ※ 検索フォームの送信先（ダミー）。後で実装ができたら適切なパスに変更してください。
  get "route_search", to: "routes#search", as: :route_search

  # 既存の他ルート…
end
