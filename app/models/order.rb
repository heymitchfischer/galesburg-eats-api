class Order < ApplicationRecord
  has_many :carted_items
  belongs_to :user
  belongs_to :business
end
