class MapsController < ApplicationController
  def index
    @addresses = Address.all.select(:id, :address, :lat, :lng).order(created_at: :desc)
    @latest_address = @addresses.first

    # スキー場のサンプルデータ
    @ski_resorts = [
      {
        name: "白馬八方尾根スキー場",
        address: "長野県北安曇郡白馬村北城白馬山",
        lat: 36.7001,
        lng: 137.8311
      },
      {
        name: "苗場スキー場",
        address: "新潟県南魚沼郡湯沢町三国",
        lat: 36.8489,
        lng: 138.7386
      },
      {
        name: "志賀高原スキー場",
        address: "長野県下高井郡山ノ内町志賀高原",
        lat: 36.7456,
        lng: 138.5147
      }
    ]
  end
end
