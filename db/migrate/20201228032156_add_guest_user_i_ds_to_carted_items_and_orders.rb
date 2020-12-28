class AddGuestUserIDsToCartedItemsAndOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :carted_items, :guest_user_id, :string
    add_index :carted_items, :guest_user_id
    add_column :orders, :guest_user_id, :string
    add_index :orders, :guest_user_id
  end
end
