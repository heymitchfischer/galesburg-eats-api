class BusinessUser < ApplicationRecord
  include AllowlistRevocation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  has_many :allowlisted_jwts, foreign_key: 'business_user_id',
           class_name: 'BusinessUserAllowlistedJwt', dependent: :destroy
  has_many :business_user_connections
  has_many :businesses, through: :business_user_connections

  def logged_in?
    allowlisted_jwts.any?
  end
end
