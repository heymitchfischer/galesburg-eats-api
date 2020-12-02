class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :determine_access_to_order!, only: [:show]

  def index
    @orders = current_user.orders
  end

  def show; end

  def create
    begin
      @order = cart.checkout
      render 'show', status: 201
    rescue CartError => error
      render json: { error: error.message }, status: 500
    end
  end

  private

  def cart
    @cart ||= Cart.new(current_user)
  end

  def order
    @order ||= Order.find(params[:id])
  end

  def authenticate_access
    # Check here
  end
end
