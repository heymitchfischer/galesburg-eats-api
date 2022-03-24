json.id @business.id
json.name @business.name
json.address @business.address
json.description @business.description
json.slug @business.slug
json.thumbnail_image_url @business.thumbnail_image_url

json.menus @business.menus do |menu|
  json.id menu.id
  json.name menu.name

  json.menu_sections menu.menu_sections do |section|
    json.id section.id
    json.name section.name

    json.menu_items section.menu_items do |item|
      json.id item.id
      json.name item.name
      json.price item.price
    end
  end
end
