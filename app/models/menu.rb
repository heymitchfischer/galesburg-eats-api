class Menu < ApplicationRecord
  belongs_to :business
  has_many :menu_sections

  def as_json(options)
    super(include: :menu_sections)
  end
end
