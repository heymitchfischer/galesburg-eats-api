class AddBusinessIdToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :business_id, :integer
  end
end
