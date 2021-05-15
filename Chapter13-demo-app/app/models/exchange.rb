class Exchange < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
