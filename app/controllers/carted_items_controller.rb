class CartedItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @carted_items = cart.current_items
  end

  def create
    begin
      cart.add_item(menu_item)
      @carted_items = cart.current_items

      render 'index', status: 201
    rescue CartError => error
      render json: { error: error.message }, status: 500
    end
  end

  def destroy
    begin
      cart.remove_item(carted_item)
      @carted_items = cart.current_items

      render 'index', status: 200
    rescue CartError => error
      render json: { error: error.message }, status: 500
    end
  end

  private

  def menu_item
    @menu_item ||= MenuItem.find(params['menu_item_id'])
  end

  def carted_item
    @carted_item ||= CartedItem.find(params[:id])
  end

  def cart
    @cart ||= Cart.new(current_user)
  end
end
