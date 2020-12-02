class MenuItem < ApplicationRecord
  belongs_to :menu_section
  has_many :carted_items

  def business
    @business ||= menu_section.menu.business
  end
end
