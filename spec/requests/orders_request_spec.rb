require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  describe '#index' do
    context 'when a user is signed in' do
      let(:email)    { 'test@example.com' }
      let(:password) { 'password' }
      let(:user)     { User.find_by(email: email) }
      let(:item)     { @business_1.menu_items.first }

      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json',
          'Authorization' => @jwt,
          'Jwt-Auth'      => 'user_web_client'
        }
      end

      before do
        create_and_log_in_user(email, password)
        create_businesses
        user.cart.add_item(item)
        user.cart.add_item(item)
        user.cart.checkout
        user.cart.add_item(item)
        user.cart.checkout
      end

      it 'returns a list of the user\'s orders' do
        get(orders_path, :headers => headers)
        expect(response.status).to eq(200)
        expect(response.content_type).to include('application/json')

        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to be_an_instance_of(Array)
        expect(parsed_body.length).to eq(2)

        order = parsed_body.first
        expect(order).to be_an_instance_of(Hash)
        expect(order.keys).to eq(ORDER_KEYS)
        expect(order['carted_items']).to be_an_instance_of(Array)
        expect(order['carted_items'].length).to eq(2)

        ordered_item = order['carted_items'].first
        expect(ordered_item).to be_an_instance_of(Hash)
        expect(ordered_item.keys).to eq(CARTED_ITEMS_KEYS)
        expect(ordered_item['menu_item_id']).to eq(item.id)
      end
    end

    context 'when a user is not signed in' do
      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json'
        }
      end

      it 'does not get a list of orders and instead returns an error message' do
        get(orders_path, :headers => headers)
        expect(response.status).to eq(401)
        expect(response.content_type).to include('application/json')

        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to be_an_instance_of(Hash)
        expect(parsed_body.keys).to include('error')
      end
    end
  end

  describe '#create' do
    context 'when a user is signed in' do
      let(:email)    { 'test@example.com' }
      let(:password) { 'password' }
      let(:user)     { User.find_by(email: email) }
      let(:item_1)   { @business_1.menu_items.first }
      let(:item_2)   { @business_2.menu_items.first }

      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json',
          'Authorization' => @jwt,
          'Jwt-Auth'      => 'user_web_client'
        }
      end

      before do
        create_and_log_in_user(email, password)
        create_businesses
      end

      context 'when the user has an empty cart' do
        it 'does not create an order and returns an error message' do
          post(orders_path, :headers => headers)
          expect(response.status).to eq(500)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Hash)
          expect(parsed_body.keys).to include('error')
          expect(parsed_body['error']).to eq('There are no items in the cart.')
        end
      end

      context 'when the user has items in their cart' do
        before do
          user.cart.add_item(item_1)
          user.cart.add_item(item_1)
        end

        it 'creates a new order and updates the items in the cart' do
          post(orders_path, :headers => headers)
          expect(response.status).to eq(201)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Hash)
          expect(parsed_body.keys).to eq(ORDER_KEYS)
          expect(parsed_body['total_price']).to eq(2398)
          expect(parsed_body['carted_items']).to be_an_instance_of(Array)
          expect(parsed_body['carted_items'].length).to eq(2)

          ordered_item = parsed_body['carted_items'].first
          expect(ordered_item).to be_an_instance_of(Hash)
          expect(ordered_item.keys).to eq(CARTED_ITEMS_KEYS)
          expect(ordered_item['menu_item_id']).to eq(item_1.id)
          expect(user.current_items.length).to eq(0)
        end
      end

      context 'when the user inexplicably has items from different businesses' do
        before do
          # Skipping the cart method here because we don't want the same-business validation
          CartedItem.create(user_id: user.id, menu_item_id: item_1.id)
          CartedItem.create(user_id: user.id, menu_item_id: item_2.id)
        end

        it 'does not create a new order and returns an error message' do
          post(orders_path, :headers => headers)
          expect(response.status).to eq(500)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Hash)
          expect(parsed_body.keys).to include('error')
          expect(parsed_body['error']).to eq('Cart has items from different businesses.')
          expect(user.current_items.length).to eq(2)
        end
      end
    end

    context 'when a user is not signed in' do
      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json'
        }
      end

      it 'does not add create a new order and returns an error message' do
        post(orders_path, :headers => headers)
        expect(response.status).to eq(401)
        expect(response.content_type).to include('application/json')

        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to be_an_instance_of(Hash)
        expect(parsed_body.keys).to include('error')
      end
    end
  end

  describe '#show' do
    context 'when a user is signed in' do
      let(:email)    { 'test@example.com' }
      let(:password) { 'password' }
      let(:user)     { User.find_by(email: email) }
      let(:item)     { @business_1.menu_items.first }

      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json',
          'Authorization' => @jwt,
          'Jwt-Auth'      => 'user_web_client'
        }
      end

      before do
        create_and_log_in_user(email, password)
        create_businesses
      end

      context 'when the user has an order' do
        before do
          user.cart.add_item(item)
          user.cart.add_item(item)
          user.cart.checkout
        end

        it 'returns the order details' do
          get(order_path(Order.last), :headers => headers)
          expect(response.status).to eq(200)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Hash)
          expect(parsed_body.keys).to eq(ORDER_KEYS)
          expect(parsed_body['total_price']).to eq(2398)
          expect(parsed_body['carted_items']).to be_an_instance_of(Array)
          expect(parsed_body['carted_items'].length).to eq(2)

          ordered_item = parsed_body['carted_items'].first
          expect(ordered_item).to be_an_instance_of(Hash)
          expect(ordered_item.keys).to eq(CARTED_ITEMS_KEYS)
          expect(ordered_item['menu_item_id']).to eq(item.id)
        end
      end

      context 'when a different user has the order' do
        let(:user_2) { create_user('test2@example.com', 'password') }

        before do
          user_2.cart.add_item(item)
          user_2.cart.add_item(item)
          user_2.cart.checkout
        end

        it 'returns the order details' do
          get(order_path(Order.last), :headers => headers)
          expect(response.status).to eq(403)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Hash)
          expect(parsed_body.keys).to include('error')
          expect(parsed_body['error']).to eq('User does not have access to that order.')
        end
      end
    end

    context 'when a user is not signed in' do
      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json'
        }
      end

      it 'does not add create a new order and returns an error message' do
        get(order_path(1), :headers => headers)
        expect(response.status).to eq(401)
        expect(response.content_type).to include('application/json')

        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to be_an_instance_of(Hash)
        expect(parsed_body.keys).to include('error')
      end
    end
  end
end
