json.id @order.id
json.created_at @order.created_at
json.business_name @order.business.name
json.business_slug @order.business.slug
json.business_thumbnail_image_url @order.business.thumbnail_image_url
json.total_price @order.total_price

json.carted_items @order.carted_items do |carted_item|
  json.id carted_item.id
  json.menu_item_id carted_item.menu_item.id
  json.menu_item_name carted_item.menu_item.name
  json.business_id carted_item.business.id
  json.business_name carted_item.business.name
  json.price carted_item.menu_item.price
end
