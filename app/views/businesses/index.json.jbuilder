json.array! @businesses do |business|
  json.id business.id
  json.name business.name
  json.address business.address
  json.description business.description
  json.slug business.slug
end