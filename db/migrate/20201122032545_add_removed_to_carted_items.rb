class AddRemovedToCartedItems < ActiveRecord::Migration[6.0]
  def change
    add_column :carted_items, :removed, :boolean, default: false
  end
end
