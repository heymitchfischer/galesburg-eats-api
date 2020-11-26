class User < ApplicationRecord
  include AllowlistRevocation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  has_many :allowlisted_jwts, foreign_key: 'user_id',
           class_name: 'UserAllowlistedJwt', dependent: :destroy
  has_many :carted_items
  has_many :orders

  def items_in_cart
    carted_items.where(order_id: nil, removed: false)
  end

  def logged_in?
    allowlisted_jwts.any?
  end
end

