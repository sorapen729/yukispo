class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name, length: { maximum: 6, allow_blank: true }
  validates :first_name, length: { maximum: 6, allow_blank: true }
end
