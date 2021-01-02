# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end

# Define constants here that will be used to check API responses
USER_KEYS = %w[id email created_at updated_at first_name last_name phone_number]
BUSINESS_USER_KEYS = %w[id email created_at updated_at]
BUSINESSES_KEYS = %w[id name address description slug image_url].freeze
BUSINESS_KEYS = %w[id name address description slug image_url menus].freeze
MENU_KEYS = %w[id name menu_sections].freeze
MENU_SECTION_KEYS = %w[id name menu_items].freeze
MENU_ITEM_KEYS = %w[id name price].freeze
CARTED_ITEMS_KEYS = %w[id menu_item_id menu_item_name business_id business_name price].freeze
ORDER_KEYS = %w[id created_at business_name business_slug business_image_url total_price carted_items].freeze

def create_user(email, password)
  User.create(email: email,
              password: password,
              password_confirmation: password,
              first_name: 'Test',
              last_name: 'User',
              phone_number: '13095555555')
end

def log_user_in(email, password)
  headers = {
    'Accept'       => 'application/json',
    'Content-Type' => 'application/json',
    'Jwt-Auth'     => 'user_web_client'
  }

  params = {
    'user' => {
      'email'    => email,
      'password' => password
    }
  }.to_json

  post(user_session_path, :params => params, :headers => headers)

  @jwt = response.headers['Authorization']
end

def create_and_log_in_user(email, password)
  create_user(email, password)
  log_user_in(email, password)
end

def create_business_user(email, password)
  BusinessUser.create(email: email,
                      password: password,
                      password_confirmation: password)
end

def log_business_user_in(email, password)
  headers = {
    'Accept'       => 'application/json',
    'Content-Type' => 'application/json',
    'Jwt-Auth'     => 'business_web_client'
  }

  params = {
    'business_user' => {
      'email'    => email,
      'password' => password
    }
  }.to_json

  post(business_user_session_path, :params => params, :headers => headers)

  @jwt = response.headers['Authorization']
end

def create_and_log_in_business_user(email, password)
  create_business_user(email, password)
  log_business_user_in(email, password)
end

def create_businesses
  @business_1 = Business.create(name: 'Landmark Café & Crêperie',
                                address: '62 S Seminary St Galesburg, IL',
                                description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.')

  @business_2 = Business.create(name: 'Baked',
                                address: '57 S Seminary St, Galesburg, IL',
                                description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.')

  @business_1.image.attach(io: File.open('public/test_images/landmark.jpg'),
                                filename: 'landmark.jpg',
                                content_type: 'image/jpg')

  @business_2.image.attach(io: File.open('public/test_images/baked.jpg'),
                                filename: 'baked.jpg',
                                content_type: 'image/jpg')

  menu_1 = Menu.create(name: 'Breakfast', business_id: @business_1.id)
  menu_2 = Menu.create(name: 'Lunch', business_id: @business_1.id)
  menu_3 = Menu.create(name: 'All Day', business_id: @business_2.id)

  menu_section_1 = MenuSection.create(name: 'Crepes', menu_id: menu_1.id)
  menu_section_2 = MenuSection.create(name: 'Beverages', menu_id: menu_1.id)
  menu_section_3 = MenuSection.create(name: 'Sandwiches', menu_id: menu_2.id)
  menu_section_4 = MenuSection.create(name: 'Dessert', menu_id: menu_2.id)
  menu_section_5 = MenuSection.create(name: 'Beverages', menu_id: menu_2.id)
  menu_section_6 = MenuSection.create(name: 'Pizza', menu_id: menu_3.id)
  menu_section_7 = MenuSection.create(name: 'Beverages', menu_id: menu_3.id)

  MenuItem.create(name: 'Landmark Crepe', menu_section_id: menu_section_1.id, price: 1199)
  MenuItem.create(name: 'BBQ Chicken Crepe', menu_section_id: menu_section_1.id, price: 1299)
  MenuItem.create(name: 'Coffee', menu_section_id: menu_section_2.id, price: 299)
  MenuItem.create(name: 'Tea', menu_section_id: menu_section_2.id, price: 199)
  MenuItem.create(name: 'Hot Chocolate', menu_section_id: menu_section_2.id, price: 299)
  MenuItem.create(name: 'The Healthy', menu_section_id: menu_section_3.id, price: 1099)
  MenuItem.create(name: 'PB&J', menu_section_id: menu_section_3.id, price: 1099)
  MenuItem.create(name: 'Ice Cream Sundae', menu_section_id: menu_section_4.id, price: 599)
  MenuItem.create(name: 'Cheesecake', menu_section_id: menu_section_4.id, price: 699)
  MenuItem.create(name: 'Coffee', menu_section_id: menu_section_5.id, price: 250)
  MenuItem.create(name: 'Tea', menu_section_id: menu_section_5.id, price: 199)
  MenuItem.create(name: 'Hot Chocolate', menu_section_id: menu_section_5.id, price: 250)
  MenuItem.create(name: 'Cheese', menu_section_id: menu_section_6.id, price: 1499)
  MenuItem.create(name: 'Sausage', menu_section_id: menu_section_6.id, price: 1599)
  MenuItem.create(name: 'Pepperoni', menu_section_id: menu_section_6.id, price: 1599)
  MenuItem.create(name: 'Sweet Corn', menu_section_id: menu_section_6.id, price: 1699)
  MenuItem.create(name: 'Cider', menu_section_id: menu_section_7.id, price: 599)
  MenuItem.create(name: 'Beer', menu_section_id: menu_section_7.id, price: 499)
  MenuItem.create(name: 'Wine', menu_section_id: menu_section_7.id, price: 599)
end
