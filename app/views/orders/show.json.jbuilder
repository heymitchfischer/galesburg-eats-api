json.id @order.id
json.created_at @order.created_at
json.business_name @order.business.name
json.business_slug @order.business.slug
json.business_image_url @order.business.image_url

json.carted_items @order.carted_items do |carted_item|
  json.id carted_item.id
  json.menu_item_id carted_item.menu_item.id
  json.menu_item_name carted_item.menu_item.name
  json.business_id carted_item.business.id
  json.business_name carted_item.business.name
end
