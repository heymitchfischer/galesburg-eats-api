require 'rails_helper'

RSpec.describe 'CartedItems', type: :request do
  describe '#index' do
    context 'when a user is signed in' do
      let(:item)     { @business_1.menu_items.first }
      let(:email)    { 'test@example.com' }
      let(:password) { 'password' }
      let(:user)     { User.find_by(email: email) }

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

      context 'when the user has an item in their cart' do
        before { user.cart.add_item(item) }

        it 'gets the items in the user\'s cart' do
          get(carted_items_path, :headers => headers)
          expect(response.status).to eq(200)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Array)
          expect(parsed_body.length).to eq(1)

          item_in_cart = parsed_body.first
          expect(item_in_cart).to be_an_instance_of(Hash)
          expect(item_in_cart.keys).to eq(CARTED_ITEMS_KEYS)
          expect(item_in_cart['menu_item_id']).to eq(item.id)
          expect(user.current_items.length).to eq(1)
        end
      end

      context 'when another user has an item in their cart' do
        let(:user_2) { create_user('test2@example.com', 'password') }

        before { user_2.cart.add_item(item) }

        it 'gets the items in the user\'s cart' do
          get(carted_items_path, :headers => headers)
          expect(response.status).to eq(200)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Array)
          expect(parsed_body.length).to eq(0)
          expect(user.current_items.length).to eq(0)
          expect(user_2.current_items.length).to eq(1)
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

      before do
        create_businesses
      end

      it 'returns a guest cart and sets a cookie on the user\'s browser' do
        get(carted_items_path, :headers => headers)
        expect(response.status).to eq(200)
        expect(response.content_type).to include('application/json')

        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to be_an_instance_of(Array)
        expect(parsed_body.length).to eq(0)
        expect(cookies[:guest_user_id]).to be_truthy
      end
    end
  end

  describe '#create' do
    let(:item) { @business_1.menu_items.first }

    let(:params) do
      {
        'menu_item_id' => item.id
      }.to_json
    end

    context 'when a user is signed in' do
      let(:email)    { 'test@example.com' }
      let(:password) { 'password' }
      let(:user)     { User.find_by(email: email) }

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
        it 'adds an item to the user\'s cart' do
          post(carted_items_path, :params => params, :headers => headers)
          expect(response.status).to eq(201)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Array)
          expect(parsed_body.length).to eq(1)

          item_in_cart = parsed_body.first
          expect(item_in_cart).to be_an_instance_of(Hash)
          expect(item_in_cart.keys).to eq(CARTED_ITEMS_KEYS)
          expect(item_in_cart['menu_item_id']).to eq(item.id)
          expect(user.current_items.length).to eq(1)
        end
      end

      context 'when the user has an item in their cart' do
        before { user.cart.add_item(item) }

        it 'adds an item to the user\'s cart' do
          post(carted_items_path, :params => params, :headers => headers)
          expect(response.status).to eq(201)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Array)
          expect(parsed_body.length).to eq(2)

          item_in_cart = parsed_body.first
          expect(item_in_cart).to be_an_instance_of(Hash)
          expect(item_in_cart.keys).to eq(CARTED_ITEMS_KEYS)
          expect(item_in_cart['menu_item_id']).to eq(item.id)
          expect(user.current_items.length).to eq(2)
        end
      end

      context 'when the user has an item from a different business in their cart' do
        before { user.cart.add_item(@business_2.menu_items.first) }

        it 'does not add an item to the user\'s cart and returns an error instead' do
          post(carted_items_path, :params => params, :headers => headers)
          expect(response.status).to eq(500)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Hash)
          expect(parsed_body.keys).to include('error')
          expect(parsed_body['error']).to eq('new_item_business_id_does_not_match')
          expect(user.current_items.length).to eq(1)
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

      before { create_businesses }

      context 'when a guest user does not have a guest_user_id cookie yet' do
        it 'creates an item in a guest user\'s cart' do
          post(carted_items_path, :params => params, :headers => headers)
          expect(response.status).to eq(201)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Array)
          expect(parsed_body.length).to eq(1)

          item_in_cart = parsed_body.first
          expect(item_in_cart).to be_an_instance_of(Hash)
          expect(item_in_cart.keys).to eq(CARTED_ITEMS_KEYS)
          expect(item_in_cart['menu_item_id']).to eq(item.id)
          expect(CartedItem.last.guest_user_id).to be_truthy
          expect(CartedItem.last.user_id).to be_falsey
          expect(cookies[:guest_user_id]).to be_truthy
        end
      end

      context 'when a guest already has a guest_user_id cookie' do
        before do
          post(carted_items_path, :params => params, :headers => headers)
        end

        it 'adds an item to the same guest user\'s cart' do
          post(carted_items_path, :params => params, :headers => headers)
          expect(response.status).to eq(201)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Array)
          expect(parsed_body.length).to eq(2)

          item_in_cart = parsed_body.first
          expect(item_in_cart).to be_an_instance_of(Hash)
          expect(item_in_cart.keys).to eq(CARTED_ITEMS_KEYS)
          expect(item_in_cart['menu_item_id']).to eq(item.id)
          expect(CartedItem.last.guest_user_id).to be_truthy
          expect(CartedItem.last.user_id).to be_falsey
          expect(cookies[:guest_user_id]).to be_truthy
        end
      end

      context 'when the guest user clears their cookies' do
        before do
          post(carted_items_path, :params => params, :headers => headers)
          cookies.delete('guest_user_id')
        end

        it 'adds the item to a new guest user\'s cart' do
          post(carted_items_path, :params => params, :headers => headers)
          expect(response.status).to eq(201)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Array)
          expect(parsed_body.length).to eq(1)

          item_in_cart = parsed_body.first
          expect(item_in_cart).to be_an_instance_of(Hash)
          expect(item_in_cart.keys).to eq(CARTED_ITEMS_KEYS)
          expect(item_in_cart['menu_item_id']).to eq(item.id)
          expect(CartedItem.last.guest_user_id).to be_truthy
          expect(CartedItem.last.user_id).to be_falsey
          expect(CartedItem.first.guest_user_id).not_to eq(CartedItem.last.guest_user_id)
          expect(cookies[:guest_user_id]).to be_truthy
        end
      end
    end
  end

  describe '#destroy' do
    let(:item) { @business_1.menu_items.first }

    before do
      create_businesses
    end

    context 'when a user is signed in' do
      let(:email)       { 'test@example.com' }
      let(:password)    { 'password' }
      let(:user)        { User.find_by(email: email) }
      let(:carted_item) { user.current_items.last }

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
      end

      context 'when the user has items in their cart' do
        before do
          user.cart.add_item(item)
          user.cart.add_item(item)
        end

        it 'removes an item from the user\'s cart' do
          delete(destroy_carted_item_path(carted_item.id), :headers => headers)
          expect(response.status).to eq(200)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Array)
          expect(parsed_body.length).to eq(1)

          item_in_cart = parsed_body.first
          expect(item_in_cart).to be_an_instance_of(Hash)
          expect(item_in_cart.keys).to eq(CARTED_ITEMS_KEYS)
          expect(item_in_cart['menu_item_id']).to eq(item.id)
          expect(user.current_items.length).to eq(1)
        end
      end

      context 'when another user has the item in their cart' do
        let(:user_2)      { create_user('test2@example.com', 'password') }
        let(:carted_item) { user_2.current_items.last }

        before do
          user_2.cart.add_item(item)
        end

        it 'does not remove the item from the other user\'s cart' do
          delete(destroy_carted_item_path(carted_item.id), :headers => headers)
          expect(response.status).to eq(500)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Hash)
          expect(parsed_body.keys).to include('error')
          expect(parsed_body['error']).to eq('item_is_not_in_cart')
          expect(user_2.current_items.length).to eq(1)
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

      context 'when the correct guest cookie is set' do
        before do
          post(carted_items_path, :params => { 'menu_item_id' => item.id }.to_json, :headers => headers)
          post(carted_items_path, :params => { 'menu_item_id' => item.id }.to_json, :headers => headers)
        end

        it 'removes an item from the guest user\'s cart' do
          delete(destroy_carted_item_path(CartedItem.last), :headers => headers)
          expect(response.status).to eq(200)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Array)
          expect(parsed_body.length).to eq(1)

          item_in_cart = parsed_body.first
          expect(item_in_cart).to be_an_instance_of(Hash)
          expect(item_in_cart.keys).to eq(CARTED_ITEMS_KEYS)
          expect(item_in_cart['menu_item_id']).to eq(item.id)
          expect(CartedItem.last.guest_user_id).to be_truthy
          expect(CartedItem.last.user_id).to be_falsey
          expect(cookies[:guest_user_id]).to be_truthy
        end
      end

      context 'when the correct guest cookie is not set' do
        before do
          post(carted_items_path, :params => { 'menu_item_id' => item.id }.to_json, :headers => headers)
          cookies.delete('guest_user_id')
        end

        it 'does not remove an item from the cart' do
          delete(destroy_carted_item_path(CartedItem.last), :headers => headers)
          expect(response.status).to eq(500)
          expect(response.content_type).to include('application/json')

          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to be_an_instance_of(Hash)
          expect(parsed_body.keys).to include('error')
          expect(parsed_body['error']).to eq('item_is_not_in_cart')
          expect(cookies[:guest_user_id]).to be_truthy
        end
      end
    end
  end
end
