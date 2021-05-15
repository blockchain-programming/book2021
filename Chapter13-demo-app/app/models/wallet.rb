class Wallet < ApplicationRecord
  require 'bitcoin'

  belongs_to :user
  has_many :keys
end
