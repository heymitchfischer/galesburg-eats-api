class Business < ApplicationRecord
  include Rails.application.routes.url_helpers

  after_validation :set_slug, only: [:create, :update]
  has_many :menus
  has_many :menu_sections, through: :menus
  has_many :menu_items, through: :menu_sections
  has_many :orders
  has_one_attached :image

  def image_url
    return unless image.attached?
    return image.service_url if Rails.env.production?
    rails_blob_url(image, host: ENV['HOST_URL'])
  end

  private

  def set_slug
    self.slug = name.to_s.parameterize
  end
end
