require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user, email: 'test@example.com', password: 'password123', password_confirmation: 'password123') }

  describe 'ログイン画面' do
    before do
      visit new_user_session_path
    end

    context 'ページの表示' do
      it 'ログインページが正常に表示される' do
        expect(page).to have_current_path(new_user_session_path)
      end

      it 'ログインタイトルが表示される' do
        expect(page).to have_content('ログイン')
      end

      it 'メールアドレス入力フィールドが表示される' do
        expect(page).to have_field('メールアドレス')
      end

      it 'パスワード入力フィールドが表示される' do
        expect(page).to have_field('パスワード')
      end

      it 'ログインボタンが表示される' do
        expect(page).to have_button('ログイン')
      end

      it 'ログイン状態を保持するチェックボックスが表示される' do
        expect(page).to have_field('ログイン状態を保持する')
      end
    end

    context 'ログイン成功' do
      before do
        user # ユーザーを事前に作成
      end

      it '正しいメールアドレスとパスワードでログインできる' do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password123'
        click_button 'ログイン'

        expect(page).to have_content('ログアウト')
        expect(page).to have_current_path(root_path)
      end

      it 'ログイン後、ログインボタンが表示されなくなる' do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password123'
        click_button 'ログイン'

        expect(page).not_to have_link('ログイン')
      end

      it 'ログイン状態を保持するにチェックを入れてログインできる' do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password123'
        check 'ログイン状態を保持する'
        click_button 'ログイン'

        expect(page).to have_content('ログアウト')
      end
    end

    context 'ログイン失敗' do
      before do
        user # ユーザーを事前に作成
      end

      it '誤ったメールアドレスでログインできない' do
        fill_in 'メールアドレス', with: 'wrong@example.com'
        fill_in 'パスワード', with: 'password123'
        click_button 'ログイン'

        expect(page).to have_content('無効なメールアドレスまたはパスワードです')
        expect(page).to have_current_path(new_user_session_path)
      end

      it '誤ったパスワードでログインできない' do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'wrongpassword'
        click_button 'ログイン'

        expect(page).to have_content('無効なメールアドレスまたはパスワードです')
        expect(page).to have_current_path(new_user_session_path)
      end

      it 'メールアドレスが空の場合ログインできない' do
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'password123'
        click_button 'ログイン'

        expect(page).to have_content('無効なメールアドレスまたはパスワードです')
        expect(page).to have_current_path(new_user_session_path)
      end

      it 'パスワードが空の場合ログインできない' do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: ''
        click_button 'ログイン'

        expect(page).to have_content('無効なメールアドレスまたはパスワードです')
        expect(page).to have_current_path(new_user_session_path)
      end

      it '両方が空の場合ログインできない' do
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        click_button 'ログイン'

        expect(page).to have_content('無効なメールアドレスまたはパスワードです')
        expect(page).to have_current_path(new_user_session_path)
      end
    end

    context 'リンク' do
      it '新規登録ページへのリンクが表示される' do
        expect(page).to have_link('新規登録', href: new_user_registration_path)
      end

      it 'パスワード再設定ページへのリンクが表示される' do
        expect(page).to have_link('パスワードを忘れた方はこちら', href: new_user_password_path)
      end
    end
  end

  describe 'ログアウト機能' do
    before do
      sign_in_as user
    end

    it 'ログアウトボタンをクリックするとログアウトできる' do
      click_link 'ログアウト'

      expect(page).to have_link('ログイン')
      expect(page).not_to have_link('ログアウト')
    end

    it 'ログアウト後、TOPページにリダイレクトされる' do
      click_link 'ログアウト'

      expect(page).to have_current_path(root_path)
    end
  end
end
