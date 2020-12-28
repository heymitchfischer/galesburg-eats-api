class CartedItem < ApplicationRecord
  belongs_to :menu_item
  belongs_to :user, optional: true
  belongs_to :order, optional: true

  def business
    @business ||= menu_item.business
  end

  def guest_user
    return unless guest_user_id

    GuestUser.new(guest_user_id)
  end
end
