class CartedItem < ApplicationRecord
  belongs_to :user
  belongs_to :menu_item
  belongs_to :order, optional: true

  def business
    @business ||= menu_item.menu_section.menu.business
  end
end