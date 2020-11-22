class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders
  end

  def create
    Order.transaction do
      order = Order.create(user_id: current_user.id)
      current_user.items_in_cart.update_all(order_id: order.id)
    end

    render status: 201
  end
end
