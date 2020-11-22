class Business < ApplicationRecord
  after_validation :set_slug, only: [:create, :update]
  has_many :menus
  has_many :menu_sections, through: :menus
  has_many :menu_items, through: :menu_sections

  private

  def set_slug
    self.slug = name.to_s.parameterize
  end
end
