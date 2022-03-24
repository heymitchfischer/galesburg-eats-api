class CreateBusinessUserConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :business_user_connections do |t|
      t.integer :business_user_id
      t.integer :business_id
      t.integer :role

      t.timestamps
    end

    add_index :business_user_connections, :role
  end
end
