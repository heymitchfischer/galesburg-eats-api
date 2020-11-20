class AddSlugToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :slug, :string
  end
end
