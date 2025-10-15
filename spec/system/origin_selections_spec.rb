require 'rails_helper'

RSpec.describe 'OriginSelections', type: :system do
  describe '出発地選択画面' do
    before do
      visit new_origin_selection_path
    end

    context 'ページの表示' do
      it '出発地選択ページが正常に表示される' do
        expect(page).to have_current_path(new_origin_selection_path)
      end

      it 'タイトルが表示される' do
        expect(page).to have_content('出発地を選ぶ')
      end

      it '現在地ボタンが表示される' do
        expect(page).to have_content('現在地（開発中）')
      end

      it '住所入力ボタンが表示される' do
        expect(page).to have_content('住所入力')
      end

      it '自宅ボタンが表示される' do
        expect(page).to have_content('自宅（開発中）')
      end

      it '住所入力ボタンに正しいリンクが設定されている' do
        expect(page).to have_link('住所入力', href: new_origin_address_input_path)
      end
    end

    context 'ボタンの動作' do
      it '住所入力ボタンをクリックすると住所入力画面に遷移する' do
        click_link '住所入力'
        expect(page).to have_current_path(new_origin_address_input_path)
      end

      it '現在地ボタンは開発中のため同じページに留まる' do
        click_link '現在地（開発中）'
        # リンク先が # のため、ページ遷移せず同じページに留まることを確認
        expect(page).to have_current_path(new_origin_selection_path)
      end

      it '自宅ボタンは開発中のため同じページに留まる' do
        click_link '自宅（開発中）'
        # リンク先が # のため、ページ遷移せず同じページに留まることを確認
        expect(page).to have_current_path(new_origin_selection_path)
      end
    end
  end
end
