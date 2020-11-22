class MenuSection < ApplicationRecord
  belongs_to :menu
  has_many :menu_items

  def as_json(options)
    super(include: :menu_items)
  end
end
