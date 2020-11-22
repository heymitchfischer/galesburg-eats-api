class MenuItem < ApplicationRecord
  belongs_to :menu_section
  has_many :carted_items
end
