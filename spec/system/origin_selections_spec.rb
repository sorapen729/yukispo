require 'rails_helper'

RSpec.describe 'OriginSelections', type: :system do
  describe '出発地選択画面' do
    context 'ログインしていない場合' do
      before do
        visit new_origin_selection_path
      end

      it '出発地選択ページが正常に表示される' do
        expect(page).to have_current_path(new_origin_selection_path)
      end

      it 'タイトルが表示される' do
        expect(page).to have_content('出発地を選ぶ')
      end

      it '住所入力ボタンが表示される' do
        expect(page).to have_content('住所入力')
      end

      it '住所入力ボタンに正しいリンクが設定されている' do
        expect(page).to have_link('住所入力', href: new_origin_address_input_path)
      end

      it 'お気に入り住所ボタンは表示されない' do
        expect(page).not_to have_content('お気に入り住所を使う')
      end

      it '現在地ボタンは表示されない' do
        expect(page).not_to have_content('現在地（開発中）')
      end

      it '住所入力ボタンをクリックすると住所入力画面に遷移する' do
        click_link '住所入力'
        expect(page).to have_current_path(new_origin_address_input_path)
      end
    end

    context 'ログインしている場合' do
      let(:user) { create(:user, address: '東京都千代田区丸の内1-9-1') }

      before do
        sign_in_as user
        visit new_origin_selection_path
      end

      it '現在地ボタンが表示される' do
        expect(page).to have_content('現在地（開発中）')
      end

      it 'お気に入り住所ボタンが表示される' do
        expect(page).to have_content('お気に入り住所を使う')
      end

      it '現在地ボタンは開発中のため同じページに留まる' do
        click_link '現在地（開発中）'
        expect(page).to have_current_path(new_origin_selection_path)
      end

      it 'お気に入り住所ボタンをクリックすると検索条件設定画面に遷移する' do
        click_button 'お気に入り住所を使う'
        expect(page).to have_current_path(new_search_filter_path)
      end
    end
  end
end
