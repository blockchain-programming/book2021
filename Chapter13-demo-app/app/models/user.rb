class User < ApplicationRecord
  has_many :exchanges
  has_one :finance
  has_one :wallet

  validates :email, {presence: true, uniqueness: true}
  validates :password, {presence: true}
end
