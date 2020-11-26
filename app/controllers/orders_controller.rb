class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders
  end

  def create
    # TODO: Check here to make sure that the user has items in cart

    # TODO: Check here to make sure that all items in cart belong to same business
    # business_id = current_user.business_id_from_cart
    business_id = current_user.items_in_cart.first.business.id

    Order.transaction do
      order = Order.create(user_id: current_user.id, business_id: business_id)
      current_user.items_in_cart.update_all(order_id: order.id)
    end

    render status: 201
  end
end
