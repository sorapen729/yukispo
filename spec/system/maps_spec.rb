require 'rails_helper'

RSpec.describe 'Maps', type: :system do
  describe 'マップ表示画面' do
    let!(:address1) { create(:address, address: '東京都千代田区丸の内1-9-1', lat: 35.6812, lng: 139.7671) }
    let!(:address2) { create(:address, address: '東京都渋谷区1-1-1', lat: 35.6598, lng: 139.7006) }

    context 'ページの表示' do
      before do
        visit maps_path
      end

      it 'マップページが正常に表示される' do
        expect(page).to have_current_path(maps_path, ignore_query: true)
      end

      it 'ページタイトルが表示される' do
        expect(page).to have_content('ルート候補')
      end

      it 'マップ要素が存在する' do
        expect(page).to have_selector('#map')
      end

      it 'スキー場情報セクションが表示される' do
        expect(page).to have_selector('#ski-resorts-info')
      end

      it 'スキー場情報のタイトルが表示される' do
        expect(page).to have_content('近隣スキー場ランキング（上位3箇所）')
      end

      it 'スキー場リストコンテナが存在する' do
        expect(page).to have_selector('#ski-resorts-list')
      end
    end

    context '住所データがある場合', js: true do
      before do
        visit maps_path
        sleep 1 # JavaScriptの実行を待つ
      end

      it '最新の住所データがJavaScriptに渡される' do
        # ページソースに最新の住所が含まれていることを確認
        expect(page.html).to include(address1.address)
      end

      it '住所データの緯度経度がJavaScriptに渡される' do
        expect(page.html).to include(address1.lat.to_s)
        expect(page.html).to include(address1.lng.to_s)
      end
    end

    context 'スキー場データ' do
      before do
        visit maps_path
      end

      it 'スキー場データがJavaScriptに渡される' do
        expect(page.html).to include('白馬八方尾根スキー場')
        expect(page.html).to include('苗場スキー場')
        expect(page.html).to include('志賀高原スキー場')
      end

      it 'スキー場の住所がJavaScriptに渡される' do
        expect(page.html).to include('長野県北安曇郡白馬村北城白馬山')
        expect(page.html).to include('新潟県南魚沼郡湯沢町三国')
        expect(page.html).to include('長野県下高井郡山ノ内町志賀高原')
      end

      it 'スキー場の緯度経度がJavaScriptに渡される' do
        # 白馬八方尾根スキー場の座標
        expect(page.html).to include('36.7001')
        expect(page.html).to include('137.8311')
      end
    end

    context '住所データがない場合' do
      before do
        Address.destroy_all
        visit maps_path
      end

      it 'ページが正常に表示される' do
        expect(page).to have_content('ルート候補')
      end

      it 'マップ要素が存在する' do
        expect(page).to have_selector('#map')
      end

      it 'スキー場情報セクションが表示される' do
        expect(page).to have_content('近隣スキー場ランキング（上位3箇所）')
      end
    end

    context 'クエリパラメータがある場合' do
      it '距離パラメータを受け取れる' do
        visit maps_path(origin_address: { distance: '10000' })
        expect(page).to have_current_path(maps_path, ignore_query: true)
        expect(current_url).to include('origin_address%5Bdistance%5D=10000')
      end

      it '時間パラメータを受け取れる' do
        visit maps_path(origin_address: { time: '60' })
        expect(page).to have_current_path(maps_path, ignore_query: true)
        expect(current_url).to include('origin_address%5Btime%5D=60')
      end

      it '距離と時間の両方のパラメータを受け取れる' do
        visit maps_path(origin_address: { distance: '50000', time: '120' })
        expect(page).to have_current_path(maps_path, ignore_query: true)
        expect(current_url).to include('origin_address%5Bdistance%5D=50000')
        expect(current_url).to include('origin_address%5Btime%5D=120')
      end
    end

    context 'JavaScript関数の定義' do
      before do
        visit maps_path
      end

      it 'initializeMap関数が定義されている' do
        expect(page.html).to include('function initializeMap()')
      end

      it 'createMarker関数が定義されている' do
        expect(page.html).to include('function createMarker(')
      end

      it 'createSkiResortMarker関数が定義されている' do
        expect(page.html).to include('function createSkiResortMarker(')
      end

      it 'calculateDistancesAndTimes関数が定義されている' do
        expect(page.html).to include('function calculateDistancesAndTimes(')
      end

      it 'displaySkiResorts関数が定義されている' do
        expect(page.html).to include('function displaySkiResorts(')
      end
    end

    context '検索条件設定画面からの遷移', js: true do
      let(:address) { create(:address, address: '東京都千代田区丸の内1-9-1') }

      before do
        # 出発地の住所入力画面から検索条件設定画面への遷移を再現
        visit new_origin_address_input_path
        fill_in 'origin_address_address', with: address.address

        # JavaScriptを使って緯度経度を設定
        page.execute_script("document.getElementById('origin_address_lat').value = '35.6812'")
        page.execute_script("document.getElementById('origin_address_lng').value = '139.7671'")

        click_button '決定'

        # 検索条件を設定して検索
        select '10km以内', from: 'origin_address_distance'
        select '1時間以内', from: 'origin_address_time'
        click_button 'この条件で検索する'
      end

      it 'マップページに遷移する' do
        expect(page).to have_current_path(maps_path, ignore_query: true)
      end

      it 'マップが表示される' do
        expect(page).to have_selector('#map')
      end

      it 'スキー場情報が表示される' do
        expect(page).to have_content('近隣スキー場ランキング（上位3箇所）')
      end
    end
  end
end
