require 'rails_helper'

RSpec.describe 'Tops', type: :system do
  let(:user) { create(:user) }
  
  describe 'TOPページ' do
    context 'ログイン前の表示' do
      before do
        visit root_path
      end

      it 'TOPページが正常に表示される' do
        expect(page).to have_current_path(root_path)
      end

      it 'タイトルが表示される' do
        expect(page).to have_content('ゆきスポ')
        expect(page).to have_content('〜 スキー場検索アプリ 〜')
      end

      it 'スキー場を探すボタンが表示される' do
        expect(page).to have_link('スキー場を探す', href: new_origin_selection_path)
      end

      it 'ログインボタンが表示される' do
        expect(page).to have_link('ログイン')
      end

      it '新規登録リンクが表示される' do
        expect(page).to have_link('新規登録の方はこちら', href: new_user_registration_path)
      end
    end

    context 'ログイン後の表示' do
      let(:user) { create(:user, password: 'password', password_confirmation: 'password') }

      before do
        sign_in_as user
        visit root_path
      end

      it 'TOPページが正常に表示される' do
        expect(page).to have_current_path(root_path)
      end

      it 'タイトルが表示される' do
        expect(page).to have_content('ゆきスポ')
      end

      it 'スキー場を探すボタンが表示される' do
        expect(page).to have_link('スキー場を探す', href: new_origin_selection_path)
      end

      it 'ログインボタンが表示されない' do
        expect(page).not_to have_link('ログイン')
      end

      it '新規登録リンクが表示されない' do
        expect(page).not_to have_link('新規登録の方はこちら')
      end
    end
  end
end
