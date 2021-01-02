class CreateBusinessUserAllowlistedJwts < ActiveRecord::Migration[6.0]
  def change
    create_table :business_user_allowlisted_jwts do |t|
      t.string :jti, null: false
      t.string :aud, null: false
      t.datetime :exp, null: false
      t.references :business_user, foreign_key: { on_delete: :cascade }, null: false
    end

    add_index :business_user_allowlisted_jwts, :jti, unique: true
  end
end
