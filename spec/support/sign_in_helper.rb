module SignInHelper
  def sign_in_as(user, password: 'password123')
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: password
    click_button 'ログイン'
    # ログインが完了するまで待機
    expect(page).to have_content('ログアウト')
  end
end

RSpec.configure do |config|
  config.include SignInHelper, type: :system
end
