class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :last_name, presence: true, length: { maximum: 6 }
  validates :first_name, presence: true, length: { maximum: 6 }
end
