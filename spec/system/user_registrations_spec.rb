require 'rails_helper'

RSpec.describe 'UserRegistrations', type: :system do
  describe '新規登録画面' do
    before do
      visit new_user_registration_path
    end

    context 'ページの表示' do
      it '新規登録ページが正常に表示される' do
        expect(page).to have_current_path(new_user_registration_path)
      end

      it '新規登録タイトルが表示される' do
        expect(page).to have_content('新規登録')
      end

      it '姓の入力フィールドが表示される' do
        expect(page).to have_field('user_last_name')
      end

      it '名の入力フィールドが表示される' do
        expect(page).to have_field('user_first_name')
      end

      it 'メールアドレス入力フィールドが表示される' do
        expect(page).to have_field('メールアドレス')
      end

      it 'パスワード入力フィールドが表示される' do
        expect(page).to have_field('パスワード')
      end

      it 'パスワード確認入力フィールドが表示される' do
        expect(page).to have_field('パスワード（確認）')
      end

      it '登録するボタンが表示される' do
        expect(page).to have_button('登録する')
      end

      it 'パスワードの最小文字数が表示される' do
        expect(page).to have_content('6文字以上')
      end
    end

    context '新規登録成功' do
      it '正しい情報を入力すると登録できる' do
        fill_in 'user_last_name', with: '山田'
        fill_in 'user_first_name', with: '太郎'
        fill_in 'メールアドレス', with: 'newuser@example.com'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認）', with: 'password123'
        click_button '登録する'

        expect(page).to have_content('ログアウト')
        expect(page).to have_current_path(root_path)
      end

      it '登録後、ログインボタンが表示されなくなる' do
        fill_in 'user_last_name', with: '佐藤'
        fill_in 'user_first_name', with: '花子'
        fill_in 'メールアドレス', with: 'hanako@example.com'
        fill_in 'パスワード', with: 'password456'
        fill_in 'パスワード（確認）', with: 'password456'
        click_button '登録する'

        expect(page).not_to have_link('ログイン')
      end
    end

    context '新規登録失敗' do
      it '姓が空の場合登録できない' do
        fill_in 'user_last_name', with: ''
        fill_in 'user_first_name', with: '太郎'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認）', with: 'password123'
        click_button '登録する'

        expect(page).to have_content('姓 は6文字以下で入力してください')
        expect(page).to have_current_path('/users/sign_up')
      end

      it '名が空の場合登録できない' do
        fill_in 'user_last_name', with: '山田'
        fill_in 'user_first_name', with: ''
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認）', with: 'password123'
        click_button '登録する'

        expect(page).to have_content('名 は6文字以下で入力してください')
        expect(page).to have_current_path('/users/sign_up')
      end

      it 'メールアドレスが空の場合登録できない' do
        fill_in 'user_last_name', with: '山田'
        fill_in 'user_first_name', with: '太郎'
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認）', with: 'password123'
        click_button '登録する'

        expect(page).to have_content('メールアドレス を入力してください')
        expect(page).to have_current_path('/users/sign_up')
      end

      it 'メールアドレスの形式が不正な場合登録できない' do
        fill_in 'user_last_name', with: '山田'
        fill_in 'user_first_name', with: '太郎'
        fill_in 'メールアドレス', with: 'invalid_email'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認）', with: 'password123'
        click_button '登録する'

        expect(page).to have_current_path('/users/sign_up')
      end

      it 'パスワードが空の場合登録できない' do
        fill_in 'user_last_name', with: '山田'
        fill_in 'user_first_name', with: '太郎'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: ''
        fill_in 'パスワード（確認）', with: 'password123'
        click_button '登録する'

        expect(page).to have_content('パスワード を入力してください')
        expect(page).to have_current_path('/users/sign_up')
      end

      it 'パスワードが6文字未満の場合登録できない' do
        fill_in 'user_last_name', with: '山田'
        fill_in 'user_first_name', with: '太郎'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'pass'
        fill_in 'パスワード（確認）', with: 'pass'
        click_button '登録する'

        expect(page).to have_content('パスワード は6文字以上で入力してください')
        expect(page).to have_current_path('/users/sign_up')
      end

      it 'パスワードとパスワード確認が一致しない場合登録できない' do
        fill_in 'user_last_name', with: '山田'
        fill_in 'user_first_name', with: '太郎'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認）', with: 'password456'
        click_button '登録する'

        expect(page).to have_content('パスワード(確認用) とパスワードが一致しません')
        expect(page).to have_current_path('/users/sign_up')
      end

      it '既に登録済みのメールアドレスでは登録できない' do
        create(:user, email: 'existing@example.com')

        fill_in 'user_last_name', with: '山田'
        fill_in 'user_first_name', with: '太郎'
        fill_in 'メールアドレス', with: 'existing@example.com'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認）', with: 'password123'
        click_button '登録する'

        expect(page).to have_content('メールアドレス はすでに存在します')
        expect(page).to have_current_path('/users/sign_up')
      end

      it '全ての項目が空の場合登録できない' do
        click_button '登録する'

        expect(page).to have_content('姓 は6文字以下で入力してください')
        expect(page).to have_content('名 は6文字以下で入力してください')
        expect(page).to have_content('メールアドレス を入力してください')
        expect(page).to have_content('パスワード を入力してください')
        expect(page).to have_current_path('/users/sign_up')
      end
    end

    context '文字数制限' do
      it '姓が7文字以上入力できない' do
        fill_in 'user_last_name', with: '1234567890'

        last_name_field = find_field('user_last_name')
        expect(last_name_field.value.length).to be <= 6
      end

      it '名が7文字以上入力できない' do
        fill_in 'user_first_name', with: '1234567890'

        first_name_field = find_field('user_first_name')
        expect(first_name_field.value.length).to be <= 6
      end
    end
  end
end
