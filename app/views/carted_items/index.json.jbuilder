json.array! @carted_items do |carted_item|
  json.id carted_item.id
  json.menu_item_id carted_item.menu_item.id
  json.menu_item_name carted_item.menu_item.name
  json.business_id carted_item.business.id
  json.business_name carted_item.business.name
  json.price carted_item.menu_item.price
end
