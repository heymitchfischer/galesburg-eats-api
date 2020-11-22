class CreateCartedItems < ActiveRecord::Migration[6.0]
  def change
    create_table :carted_items do |t|
      t.integer :menu_item_id
      t.integer :user_id
      t.integer :order_id

      t.timestamps
    end
  end
end
