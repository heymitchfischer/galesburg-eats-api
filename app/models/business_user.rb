class BusinessUser < ApplicationRecord
  include AllowlistRevocation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: self

  has_many :allowlisted_jwts, foreign_key: 'business_user_id',
           class_name: 'BusinessUserAllowlistedJwt', dependent: :destroy

  def logged_in?
    allowlisted_jwts.any?
  end
end
