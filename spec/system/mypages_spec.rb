require 'rails_helper'

RSpec.describe 'Mypages', type: :system do
  let(:user) { create(:user, email: 'test@example.com', password: 'password123', password_confirmation: 'password123', last_name: '山田', first_name: '太郎', address: '東京都千代田区丸の内1-9-1') }

  describe 'マイページ表示機能' do
    context '未ログイン状態' do
      it 'マイページにアクセスするとログインページにリダイレクトされる' do
        visit mypage_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end

    context 'ログイン状態' do
      before do
        sign_in_as user
        visit mypage_path
      end

      it 'マイページが正常に表示される' do
        expect(page).to have_current_path(mypage_path)
      end

      it 'マイページのタイトルが表示される' do
        expect(page).to have_content('マイページ')
      end

      it 'ユーザー情報セクションが表示される' do
        expect(page).to have_content('ユーザー情報')
      end

      it 'ユーザーの姓名が表示される' do
        expect(page).to have_content('お名前')
        expect(page).to have_content('山田 太郎')
      end

      it 'ユーザーのメールアドレスが表示される' do
        expect(page).to have_content('メールアドレス')
        expect(page).to have_content('test@example.com')
      end

      it 'ユーザーの住所が表示される' do
        expect(page).to have_content('お気に入り住所')
        expect(page).to have_content('東京都千代田区丸の内1-9-1')
      end

      it 'プロフィール編集ボタンが表示される' do
        expect(page).to have_link('プロフィールを編集', href: edit_mypage_path)
      end

      it 'プロフィール編集ボタンをクリックすると編集ページに遷移する' do
        click_link 'プロフィールを編集'
        expect(page).to have_current_path(edit_mypage_path)
      end
    end

    context '住所が未設定のユーザー' do
      let(:user_without_address) { create(:user, email: 'noaddress@example.com', password: 'password123', password_confirmation: 'password123', address: nil) }

      before do
        sign_in_as user_without_address
        visit mypage_path
      end

      it '住所欄が空で表示される' do
        expect(page).to have_content('お気に入り住所')
        # 住所が空の場合、空文字が表示される
      end
    end
  end

  describe 'プロフィール編集機能' do
    context '未ログイン状態' do
      it '編集ページにアクセスするとログインページにリダイレクトされる' do
        visit edit_mypage_path
        expect(page).to have_current_path(new_user_session_path)
      end
    end

    context 'ログイン状態' do
      before do
        sign_in_as user
        visit edit_mypage_path
      end

      it '編集ページが正常に表示される' do
        expect(page).to have_current_path(edit_mypage_path)
      end

      it 'プロフィール編集のタイトルが表示される' do
        expect(page).to have_content('プロフィール編集')
      end

      it '姓の入力フィールドが表示され、現在の値が入っている' do
        expect(page).to have_field('姓', with: '山田')
      end

      it '名の入力フィールドが表示され、現在の値が入っている' do
        expect(page).to have_field('名', with: '太郎')
      end

      it 'メールアドレスの入力フィールドが表示され、現在の値が入っている' do
        expect(page).to have_field('メールアドレス', with: 'test@example.com')
      end

      it '住所の入力フィールドが表示され、現在の値が入っている' do
        expect(page).to have_field('お気に入り住所（任意）', with: '東京都千代田区丸の内1-9-1')
      end

      it '更新するボタンが表示される' do
        expect(page).to have_button('更新する')
      end

      it 'キャンセルボタンが表示される' do
        expect(page).to have_link('キャンセル', href: mypage_path)
      end

      it '必須マークが姓、名、メールアドレスに表示される' do
        within 'label[for="user_last_name"]' do
          expect(page).to have_content('必須')
        end
        within 'label[for="user_first_name"]' do
          expect(page).to have_content('必須')
        end
        within 'label[for="user_email"]' do
          expect(page).to have_content('必須')
        end
      end

      it 'キャンセルボタンをクリックするとマイページに戻る' do
        click_link 'キャンセル'
        expect(page).to have_current_path(mypage_path)
      end
    end
  end

  describe 'プロフィール更新機能' do
    context '正常な入力' do
      before do
        sign_in_as user
        visit edit_mypage_path
      end

      it '全ての項目を更新できる' do
        fill_in '姓', with: '鈴木'
        fill_in '名', with: '花子'
        fill_in 'メールアドレス', with: 'updated@example.com'
        fill_in 'お気に入り住所（任意）', with: '大阪府大阪市北区梅田1-1-1'

        click_button '更新する'

        expect(page).to have_current_path(mypage_path)
        expect(page).to have_content('プロフィールを更新しました')
        expect(page).to have_content('鈴木 花子')
        expect(page).to have_content('updated@example.com')
        expect(page).to have_content('大阪府大阪市北区梅田1-1-1')
      end

      it '姓のみを更新できる' do
        fill_in '姓', with: '佐藤'
        click_button '更新する'

        expect(page).to have_current_path(mypage_path)
        expect(page).to have_content('プロフィールを更新しました')
        expect(page).to have_content('佐藤 太郎')
      end

      it '名のみを更新できる' do
        fill_in '名', with: '次郎'
        click_button '更新する'

        expect(page).to have_current_path(mypage_path)
        expect(page).to have_content('プロフィールを更新しました')
        expect(page).to have_content('山田 次郎')
      end

      it 'メールアドレスのみを更新できる' do
        fill_in 'メールアドレス', with: 'newemail@example.com'
        click_button '更新する'

        expect(page).to have_current_path(mypage_path)
        expect(page).to have_content('プロフィールを更新しました')
        expect(page).to have_content('newemail@example.com')
      end

      it '住所のみを更新できる' do
        fill_in 'お気に入り住所（任意）', with: '北海道札幌市中央区北1条西2-1'
        click_button '更新する'

        expect(page).to have_current_path(mypage_path)
        expect(page).to have_content('プロフィールを更新しました')
        expect(page).to have_content('北海道札幌市中央区北1条西2-1')
      end

      it '住所を空にして更新できる（任意項目）' do
        fill_in 'お気に入り住所（任意）', with: ''
        click_button '更新する'

        expect(page).to have_current_path(mypage_path)
        expect(page).to have_content('プロフィールを更新しました')
      end
    end

    context '異常な入力' do
      before do
        sign_in_as user
        visit edit_mypage_path
      end

      it '姓が空の場合、更新に失敗しエラーメッセージが表示される' do
        fill_in '姓', with: ''
        click_button '更新する'

        expect(page).to have_current_path(edit_mypage_path)
        expect(page).to have_content('プロフィールの更新に失敗しました')
        expect(page).to have_content('エラー')
        expect(page).to have_field('姓', with: '')
      end

      it '名が空の場合、更新に失敗しエラーメッセージが表示される' do
        fill_in '名', with: ''
        click_button '更新する'

        expect(page).to have_current_path(edit_mypage_path)
        expect(page).to have_content('プロフィールの更新に失敗しました')
        expect(page).to have_content('エラー')
        expect(page).to have_field('名', with: '')
      end

      it 'メールアドレスが空の場合、更新に失敗しエラーメッセージが表示される' do
        fill_in 'メールアドレス', with: ''
        click_button '更新する'

        expect(page).to have_current_path(edit_mypage_path)
        expect(page).to have_content('プロフィールの更新に失敗しました')
        expect(page).to have_content('エラー')
        expect(page).to have_field('メールアドレス', with: '')
      end

      it '既に使用されているメールアドレスでは更新できない' do
        # 別のユーザーを作成
        create(:user, email: 'existing@example.com')

        fill_in 'メールアドレス', with: 'existing@example.com'
        click_button '更新する'

        expect(page).to have_current_path(edit_mypage_path)
        expect(page).to have_content('プロフィールの更新に失敗しました')
        expect(page).to have_content('エラー')
        expect(page).to have_field('メールアドレス', with: 'existing@example.com')
      end
    end
  end
end
