class Key < ApplicationRecord
  belongs_to :wallet, dependent: :destroy

  validates :public_key, {presence: true}
  validates :private_key, {presence: true}
end
