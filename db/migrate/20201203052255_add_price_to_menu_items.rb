class AddPriceToMenuItems < ActiveRecord::Migration[6.0]
  def change
    add_column :menu_items, :price, :integer
  end
end
