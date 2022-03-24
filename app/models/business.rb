class Business < ApplicationRecord
  include Rails.application.routes.url_helpers

  after_validation :set_slug, only: [:create, :update]
  has_many :menus
  has_many :menu_sections, through: :menus
  has_many :menu_items, through: :menu_sections
  has_many :orders
  has_many :business_user_connections
  has_many :business_users, through: :business_user_connections
  has_one_attached :thumbnail_image
  validates :name, presence: true
  validates :address, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /[a-z0-9]+(?:-[a-z0-9]+)*/ }
  validates :description, length: { maximum: 400 }

  def thumbnail_image_url
    return unless thumbnail_image.attached?
    return thumbnail_image.service_url if Rails.env.production?
    rails_blob_url(thumbnail_image, host: ENV['HOST_URL'])
  end

  private

  def set_slug
    self.slug = name.to_s.parameterize
  end
end
