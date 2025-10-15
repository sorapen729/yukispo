require 'rails_helper'

RSpec.describe 'OriginAddressInputs', type: :system do
  describe '出発地の住所入力画面' do
    before do
      visit new_origin_address_input_path
    end

    context 'ページの表示' do
      it '住所入力ページが正常に表示される' do
        expect(page).to have_current_path(new_origin_address_input_path)
      end

      it 'タイトルが表示される' do
        expect(page).to have_content('住所入力')
      end

      it '出発地の住所ラベルが表示される' do
        expect(page).to have_content('出発地の住所')
      end

      it '必須マークが表示される' do
        expect(page).to have_content('必須')
      end

      it '住所入力フィールドが表示される' do
        expect(page).to have_field('origin_address_address')
      end

      it '住所入力フィールドにプレースホルダーが表示される' do
        expect(page).to have_field('origin_address_address', placeholder: '例）東京都千代田区丸の内1-9-1')
      end

      it '決定ボタンが表示される' do
        expect(page).to have_button('決定')
      end

      it '入力をクリアボタンが表示される' do
        expect(page).to have_button('入力をクリア')
      end

      it '緯度の隠しフィールドが存在する' do
        expect(page).to have_field('origin_address_lat', type: 'hidden')
      end

      it '経度の隠しフィールドが存在する' do
        expect(page).to have_field('origin_address_lng', type: 'hidden')
      end
    end

    context '住所入力成功' do
      it '正しい住所を入力すると検索条件設定画面に遷移する', js: true do
        fill_in 'origin_address_address', with: '東京都千代田区丸の内1-9-1'

        # 緯度経度を直接設定（ジオコーディングAPIをモック）
        page.execute_script("document.getElementById('origin_address_lat').value = '35.6812'")
        page.execute_script("document.getElementById('origin_address_lng').value = '139.7671'")

        click_button '決定'

        expect(page).to have_current_path(new_search_filter_path)
        expect(page).to have_content('出発地が設定されました')
      end
    end

    context '住所入力失敗' do
      it '住所が空の場合はエラーが発生する' do
        click_button '決定'

        # フォーム送信後も入力画面の要素が表示されていることを確認
        expect(page).to have_field('origin_address_address')
        expect(page).to have_button('決定')
        expect(page).to have_content('住所入力')
      end

      it '住所が空の場合は同じページに留まる' do
        click_button '決定'

        # 入力フォームが再表示されていることを確認
        expect(page).to have_field('origin_address_address')
        expect(page).to have_button('決定')
        # 検索条件設定画面に遷移していないことを確認
        expect(page).not_to have_content('検索条件')
      end
    end

    context '入力フィールドの操作' do
      it '住所を入力できる' do
        fill_in 'origin_address_address', with: '東京都渋谷区'

        expect(page).to have_field('origin_address_address', with: '東京都渋谷区')
      end

      it '入力をクリアボタンで入力内容がクリアされる', js: true do
        fill_in 'origin_address_address', with: '東京都渋谷区'
        click_button '入力をクリア'

        expect(page).to have_field('origin_address_address', with: '')
      end

      it '入力をクリアボタンで緯度経度もクリアされる', js: true do
        page.execute_script("document.getElementById('origin_address_lat').value = '35.6812'")
        page.execute_script("document.getElementById('origin_address_lng').value = '139.7671'")

        click_button '入力をクリア'

        lat_value = page.evaluate_script("document.getElementById('origin_address_lat').value")
        lng_value = page.evaluate_script("document.getElementById('origin_address_lng').value")

        expect(lat_value).to eq('')
        expect(lng_value).to eq('')
      end
    end
  end
end
