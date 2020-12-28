class GuestUser
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def guest?
    true
  end

  def registered?
    false
  end

  def carted_items
    CartedItem.where(guest_user_id: id)
  end

  def orders
    Order.where(guest_user_id: id)
  end

  def current_items
    cart.current_items
  end

  def cart
    @cart ||= Cart.new(self)
  end
end
