class Order < ApplicationRecord
  has_many :carted_items
  belongs_to :user, optional: true
  belongs_to :business

  def guest_user
    return unless guest_user_id

    GuestUser.new(guest_user_id)
  end

  def placed_by
    user ? user : guest_user
  end
end
