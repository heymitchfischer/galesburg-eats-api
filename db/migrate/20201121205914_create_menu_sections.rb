class CreateMenuSections < ActiveRecord::Migration[6.0]
  def change
    create_table :menu_sections do |t|
      t.string :name
      t.integer :menu_id

      t.timestamps
    end
  end
end
