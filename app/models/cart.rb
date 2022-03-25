class CartError < StandardError; end

class Cart
  attr_accessor :user

  BUSINESS_IDS_IN_CART_DO_NOT_MATCH = 'business_ids_in_cart_do_not_match'
  NEW_ITEM_BUSINESS_ID_DOES_NOT_MATCH = 'new_item_business_id_does_not_match'
  ITEM_IS_NOT_IN_CART = 'item_is_not_in_cart'
  NO_ITEMS_IN_CART_TO_CHECKOUT = 'no_items_in_cart_to_checkout'

  def initialize(user)
    @user = user
  end

  def current_items
    if user.registered?
      CartedItem.where(user_id: user.id, order_id: nil, removed: false)
    else
      CartedItem.where(guest_user_id: user.id, order_id: nil, removed: false)
    end
  end

  def add_item(item)
    if current_items.any? && item.business.id != current_business_id
      raise CartError.new(NEW_ITEM_BUSINESS_ID_DOES_NOT_MATCH)
    end

    if user.registered?
      CartedItem.create!(user_id: user.id,
                         menu_item_id: item.id)
    else
      CartedItem.create!(guest_user_id: user.id,
                         menu_item_id: item.id)
    end
  end

  def remove_item(item)
    raise CartError.new(ITEM_IS_NOT_IN_CART) unless current_items.include?(item)

    item.update(removed: true)
  end

  def checkout
    items_to_checkout = current_items
    raise CartError.new(NO_ITEMS_IN_CART_TO_CHECKOUT) unless items_to_checkout.any?

    total_price = determine_total(current_items)

    Order.transaction do
      order =
        if user.registered?
          Order.create!(user_id: user.id, business_id: current_business_id, total_price: total_price)
        else
          Order.create!(guest_user_id: user.id, business_id: current_business_id, total_price: total_price)
        end

      items_to_checkout.each { | item| item.update(order_id: order.id) }

      # Make sure that we're returning the created order as the last line
      order
    end
  end

  def transfer_ownership_of_current_items_to(new_user)
    current_items.update_all(user_id: new_user.id, guest_user_id: nil)
  end

  private

  def determine_total(items = current_items)
    items.reduce(0) { |total, item| total + item.menu_item.price }
  end

  def current_business_id
    items = current_items
    return unless items.any?

    business_id = items.map { |item| item.business.id }.uniq

    if business_id.length > 1
      raise CartError.new(BUSINESS_IDS_IN_CART_DO_NOT_MATCH)
    end

    business_id.first
  end
end
