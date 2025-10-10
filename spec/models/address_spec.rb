require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'バリデーションチェック' do
    subject { build(:address) }

    context '住所' do
      it '住所がある場合にvalidになるか' do
        address = build(:address, address: '東京都渋谷区1-1-1')
        expect(address).to be_valid
      end

      it '住所がない場合にバリデーションが機能してinvalidになるか' do
        address = build(:address, address: nil)
        expect(address).to be_invalid
        expect(address.errors[:address]).to include('を入力してください')
      end

      it '住所が空文字の場合にバリデーションが機能してinvalidになるか' do
        address = build(:address, address: '')
        expect(address).to be_invalid
        expect(address.errors[:address]).to include('を入力してください')
      end
    end
  end
end
