require 'rails_helper'

RSpec.describe 'SearchFilters', type: :system do
  describe '検索条件の絞り込み画面', js: true do
    let(:address) { create(:address, address: '東京都千代田区丸の内1-9-1') }

    before do
      # 出発地の住所入力画面から検索条件設定画面への遷移を再現
      visit new_origin_address_input_path
      fill_in 'origin_address_address', with: address.address

      # JavaScriptを使って緯度経度を設定（ジオコーディングAPIのモック）
      page.execute_script("document.getElementById('origin_address_lat').value = '35.6812'")
      page.execute_script("document.getElementById('origin_address_lng').value = '139.7671'")

      click_button '決定'
    end

    context 'ページの表示' do
      it '検索条件設定ページが正常に表示される' do
        expect(page).to have_current_path(new_search_filter_path)
      end

      it 'タイトルが表示される' do
        expect(page).to have_content('検索条件を設定')
      end

      it '出発地情報が表示される' do
        expect(page).to have_content('出発地')
        expect(page).to have_content('東京都千代田区丸の内1-9-1')
      end

      it '移動距離の絞り込みラベルが表示される' do
        expect(page).to have_content('移動距離で絞り込み')
      end

      it '移動時間の絞り込みラベルが表示される' do
        expect(page).to have_content('移動時間で絞り込み')
      end

      it '検索ボタンが表示される' do
        expect(page).to have_button('この条件で検索する')
      end
    end

    context '距離の選択フィールド' do
      it '距離の選択フィールドが表示される' do
        expect(page).to have_select('origin_address_distance')
      end

      it '距離の選択肢が正しく表示される' do
        within('select[name="origin_address[distance]"]') do
          expect(page).to have_content('指定しない(開発中)')
          expect(page).to have_content('5km以内')
          expect(page).to have_content('10km以内')
          expect(page).to have_content('50km以内')
          expect(page).to have_content('100km以内')
          expect(page).to have_content('200km以内')
          expect(page).to have_content('300km以内')
        end
      end

      it 'デフォルトで「指定しない(開発中)」が選択されている' do
        expect(page).to have_select('origin_address_distance', selected: '指定しない(開発中)')
      end

      it '距離を選択できる' do
        select '10km以内', from: 'origin_address_distance'
        expect(page).to have_select('origin_address_distance', selected: '10km以内')
      end
    end

    context '時間の選択フィールド' do
      it '時間の選択フィールドが表示される' do
        expect(page).to have_select('origin_address_time')
      end

      it '時間の選択肢が正しく表示される' do
        within('select[name="origin_address[time]"]') do
          expect(page).to have_content('指定しない(開発中)')
          expect(page).to have_content('30分以内')
          expect(page).to have_content('1時間以内')
          expect(page).to have_content('2時間以内')
          expect(page).to have_content('3時間以内')
          expect(page).to have_content('4時間以内')
        end
      end

      it 'デフォルトで「指定しない(開発中)」が選択されている' do
        expect(page).to have_select('origin_address_time', selected: '指定しない(開発中)')
      end

      it '時間を選択できる' do
        select '1時間以内', from: 'origin_address_time'
        expect(page).to have_select('origin_address_time', selected: '1時間以内')
      end
    end

    context '検索条件の送信' do
      it '検索ボタンをクリックすると地図ページに遷移する' do
        click_button 'この条件で検索する'
        expect(page).to have_current_path(maps_path, ignore_query: true)
      end

      it '距離と時間を指定して検索できる' do
        select '10km以内', from: 'origin_address_distance'
        select '1時間以内', from: 'origin_address_time'
        click_button 'この条件で検索する'

        expect(page).to have_current_path(maps_path, ignore_query: true)
        expect(current_url).to include('origin_address%5Bdistance%5D=10000')
        expect(current_url).to include('origin_address%5Btime%5D=60')
      end

      it '距離のみ指定して検索できる' do
        select '50km以内', from: 'origin_address_distance'
        click_button 'この条件で検索する'

        expect(page).to have_current_path(maps_path, ignore_query: true)
        expect(current_url).to include('origin_address%5Bdistance%5D=50000')
      end

      it '時間のみ指定して検索できる' do
        select '2時間以内', from: 'origin_address_time'
        click_button 'この条件で検索する'

        expect(page).to have_current_path(maps_path, ignore_query: true)
        expect(current_url).to include('origin_address%5Btime%5D=120')
      end

      it '条件を指定せずに検索できる' do
        click_button 'この条件で検索する'
        expect(page).to have_current_path(maps_path, ignore_query: true)
      end
    end
  end

  describe '出発地が設定されていない場合の検索条件絞り込み画面' do
    context 'ページの表示' do
      it '出発地情報が表示されない' do
        visit new_search_filter_path

        expect(page).not_to have_content('東京都千代田区丸の内1-9-1')
        expect(page).not_to have_selector('.bg-blue-50')
      end

      it 'ページは正常に表示される' do
        visit new_search_filter_path

        expect(page).to have_content('検索条件を設定')
        expect(page).to have_button('この条件で検索する')
      end
    end
  end
end
