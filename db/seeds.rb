# stand_in_description = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

# Business.create(name: 'Landmark Café & Crêperie', address: '62 S Seminary St Galesburg, IL', description: stand_in_description)
# Business.create(name: 'Baked', address: '57 S Seminary St, Galesburg, IL', description: stand_in_description)
# Business.create(name: 'Koreana', address: '323 E Main St, Galesburg IL', description: stand_in_description)
# Business.create(name: 'Grandview', address: '2221 Grand Ave', description: stand_in_description)

# Menu.create(name: 'Breakfast', business_id: 1)
# Menu.create(name: 'Lunch', business_id: 1)
# Menu.create(name: 'All Day', business_id: 2)
# Menu.create(name: 'All Day', business_id: 3)
# Menu.create(name: 'Brunch', business_id: 4)

# MenuSection.create(name: 'Crepes', menu_id: 1)
# MenuSection.create(name: 'Beverages', menu_id: 1)
# MenuSection.create(name: 'Sandwiches', menu_id: 2)
# MenuSection.create(name: 'Dessert', menu_id: 2)
# MenuSection.create(name: 'Beverages', menu_id: 2)
# MenuSection.create(name: 'Pizza', menu_id: 3)
# MenuSection.create(name: 'Beverages', menu_id: 3)
# MenuSection.create(name: 'Rice', menu_id: 4)
# MenuSection.create(name: 'Noodles', menu_id: 4)
# MenuSection.create(name: 'Beverages', menu_id: 4)
# MenuSection.create(name: 'Pancakes', menu_id: 5)
# MenuSection.create(name: 'Sides', menu_id: 5)
# MenuSection.create(name: 'Beverages', menu_id: 5)

# MenuItem.create(name: 'Landmark Crepe', menu_section_id: 1, price: 1199)
# MenuItem.create(name: 'BBQ Chicken Crepe', menu_section_id: 1, price: 1299)
# MenuItem.create(name: 'Coffee', menu_section_id: 2, price: 299)
# MenuItem.create(name: 'Tea', menu_section_id: 2, price: 199)
# MenuItem.create(name: 'Hot Chocolate', menu_section_id: 2, price: 299)
# MenuItem.create(name: 'The Healthy', menu_section_id: 3, price: 1099)
# MenuItem.create(name: 'PB&J', menu_section_id: 3, price: 1099)
# MenuItem.create(name: 'Ice Cream Sundae', menu_section_id: 4, price: 599)
# MenuItem.create(name: 'Cheesecake', menu_section_id: 4, price: 699)
# MenuItem.create(name: 'Coffee', menu_section_id: 5, price: 250)
# MenuItem.create(name: 'Tea', menu_section_id: 5, price: 199)
# MenuItem.create(name: 'Hot Chocolate', menu_section_id: 5, price: 250)
# MenuItem.create(name: 'Cheese', menu_section_id: 6, price: 1499)
# MenuItem.create(name: 'Sausage', menu_section_id: 6, price: 1599)
# MenuItem.create(name: 'Pepperoni', menu_section_id: 6, price: 1599)
# MenuItem.create(name: 'Sweet Corn', menu_section_id: 6, price: 1699)
# MenuItem.create(name: 'Cider', menu_section_id: 7, price: 599)
# MenuItem.create(name: 'Beer', menu_section_id: 7, price: 499)
# MenuItem.create(name: 'Wine', menu_section_id: 7, price: 599)
# MenuItem.create(name: 'Vegetable Fried Rice', menu_section_id: 8, price: 899)
# MenuItem.create(name: 'Chicken Friend Rice', menu_section_id: 8, price: 999)
# MenuItem.create(name: 'Bibimbap', menu_section_id: 8, price: 1099)
# MenuItem.create(name: 'Jap Chae', menu_section_id: 9, price: 1099)
# MenuItem.create(name: 'Cider', menu_section_id: 10, price: 599)
# MenuItem.create(name: 'Beer', menu_section_id: 10, price: 450)
# MenuItem.create(name: 'Wine', menu_section_id: 10, price: 599)
# MenuItem.create(name: 'Classic Pancakes', menu_section_id: 11, price: 899)
# MenuItem.create(name: 'Chocolate Chip Pancakes', menu_section_id: 11, price: 999)
# MenuItem.create(name: 'Bacon', menu_section_id: 12, price: 399)
# MenuItem.create(name: 'Toast', menu_section_id: 12, price: 299)
# MenuItem.create(name: 'Hashbrowns', menu_section_id: 12, price: 299)
# MenuItem.create(name: 'Coffee', menu_section_id: 13, price: 299)
# MenuItem.create(name: 'Orange Juice', menu_section_id: 13, price: 299)

# Business.find(1).thumbnail_image.attach(io: File.open('public/test_images/landmark.jpg'), filename: 'landmark.jpg', content_type: 'image/jpg')
# Business.find(2).thumbnail_image.attach(io: File.open('public/test_images/baked.jpg'), filename: 'baked.jpg', content_type: 'image/jpg')
# Business.find(3).thumbnail_image.attach(io: File.open('public/test_images/koreana.jpg'), filename: 'koreana.jpg', content_type: 'image/jpg')
# Business.find(4).thumbnail_image.attach(io: File.open('public/test_images/grandview.jpg'), filename: 'grandview.jpg', content_type: 'image/jpg')
