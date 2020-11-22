class CartedItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @carted_items = current_user.items_in_cart
  end

  def create
    CartedItem.create(user_id: current_user.id,
                      menu_item_id: params['menu_item_id'])

    @carted_items = current_user.items_in_cart
    render 'index', status: 201
  end

  def destroy
    carted_item = CartedItem.find(params[:id])
    carted_item.update(removed: true)

    @carted_items = current_user.items_in_cart
    render 'index', status: 200
  end
end
