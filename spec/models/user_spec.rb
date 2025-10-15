require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    subject { build(:user) }

    context '姓' do
      it '姓がある場合にvalidになるか' do
        user = build(:user, last_name: '山田')
        expect(user).to be_valid
      end

      it '姓がない場合にバリデーションが機能してinvalidになるか' do
        user = build(:user, last_name: nil)
        expect(user).to be_invalid
        expect(user.errors[:last_name]).to include('は6文字以下で入力してください')
      end

      it '姓が6文字を超える場合にバリデーションが機能してinvalidになるか' do
        user = build(:user, last_name: 'あ' * 7)
        expect(user).to be_invalid
        expect(user.errors[:last_name]).to include('は6文字以下で入力してください')
      end

      it '姓が6文字以内の場合にvalidになるか' do
        user = build(:user, last_name: 'あ' * 6)
        expect(user).to be_valid
      end
    end

    context '名' do
      it '名がある場合にvalidになるか' do
        user = build(:user, first_name: '太郎')
        expect(user).to be_valid
      end

      it '名がない場合にバリデーションが機能してinvalidになるか' do
        user = build(:user, first_name: nil)
        expect(user).to be_invalid
        expect(user.errors[:first_name]).to include('は6文字以下で入力してください')
      end

      it '名が6文字を超える場合にバリデーションが機能してinvalidになるか' do
        user = build(:user, first_name: 'あ' * 7)
        expect(user).to be_invalid
        expect(user.errors[:first_name]).to include('は6文字以下で入力してください')
      end

      it '名が6文字以内の場合にvalidになるか' do
        user = build(:user, first_name: 'あ' * 6)
        expect(user).to be_valid
      end
    end

    context 'メールアドレス' do
      it 'メールアドレスがある場合にvalidになるか' do
        user = build(:user, email: 'test@example.com')
        expect(user).to be_valid
      end

      it 'メールアドレスがない場合にバリデーションが機能してinvalidになるか' do
        user = build(:user, email: nil)
        expect(user).to be_invalid
      end

      it '一意なメールアドレスでない場合はバリデーションが機能してinvalidになるか' do
        create(:user, email: 'duplicate@example.com')
        user = build(:user, email: 'duplicate@example.com')
        expect(user).to be_invalid
      end
    end

    context 'パスワード' do
      it 'パスワードがない場合にバリデーションが機能してinvalidになるか' do
        user = build(:user, password: nil)
        expect(user).to be_invalid
      end

      it 'パスワードが6文字未満の場合にバリデーションが機能してinvalidになるか' do
        user = build(:user, password: '12345', password_confirmation: '12345')
        expect(user).to be_invalid
      end

      it 'パスワードが6文字以上の場合にvalidになるか' do
        user = build(:user, password: '123456', password_confirmation: '123456')
        expect(user).to be_valid
      end
    end
  end

  describe 'Deviseモジュール' do
    it 'database_authenticatableを含むこと' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'registerableを含むこと' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'recoverableを含むこと' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'rememberableを含むこと' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'validatableを含むこと' do
      expect(User.devise_modules).to include(:validatable)
    end
  end
end
