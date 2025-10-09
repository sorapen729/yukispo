require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    context 'last_name' do
      it 'is valid with a valid last_name' do
        user = build(:user, last_name: '山田')
        expect(user).to be_valid
      end

      it 'is invalid without last_name' do
        user = build(:user, last_name: nil)
        expect(user).to be_invalid
        expect(user.errors[:last_name]).to include('を入力してください')
      end

      it 'is invalid with last_name longer than 6 characters' do
        user = build(:user, last_name: 'あ' * 7)
        expect(user).to be_invalid
        expect(user.errors[:last_name]).to include('は6文字以下で入力してください')
      end

      it 'is valid with last_name of 6 characters' do
        user = build(:user, last_name: 'あ' * 6)
        expect(user).to be_valid
      end
    end

    context 'first_name' do
      it 'is valid with a valid first_name' do
        user = build(:user, first_name: '太郎')
        expect(user).to be_valid
      end

      it 'is invalid without first_name' do
        user = build(:user, first_name: nil)
        expect(user).to be_invalid
        expect(user.errors[:first_name]).to include('を入力してください')
      end

      it 'is invalid with first_name longer than 6 characters' do
        user = build(:user, first_name: 'あ' * 7)
        expect(user).to be_invalid
        expect(user.errors[:first_name]).to include('は6文字以下で入力してください')
      end

      it 'is valid with first_name of 6 characters' do
        user = build(:user, first_name: 'あ' * 6)
        expect(user).to be_valid
      end
    end

    context 'email' do
      it 'is valid with a valid email' do
        user = build(:user, email: 'test@example.com')
        expect(user).to be_valid
      end

      it 'is invalid without email' do
        user = build(:user, email: nil)
        expect(user).to be_invalid
      end

      it 'is invalid with duplicate email' do
        create(:user, email: 'duplicate@example.com')
        user = build(:user, email: 'duplicate@example.com')
        expect(user).to be_invalid
      end
    end

    context 'password' do
      it 'is invalid without password' do
        user = build(:user, password: nil)
        expect(user).to be_invalid
      end

      it 'is invalid with password shorter than 6 characters' do
        user = build(:user, password: '12345', password_confirmation: '12345')
        expect(user).to be_invalid
      end

      it 'is valid with password of 6 or more characters' do
        user = build(:user, password: '123456', password_confirmation: '123456')
        expect(user).to be_valid
      end
    end
  end

  describe 'devise modules' do
    it 'includes database_authenticatable' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes validatable' do
      expect(User.devise_modules).to include(:validatable)
    end
  end
end
