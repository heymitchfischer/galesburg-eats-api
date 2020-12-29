require 'rails_helper'

RSpec.describe 'Users::SessionsController', type: :request do
  describe '#create' do
    let(:email)    { 'test@example.com' }
    let(:password) { 'password' }
    let(:user)     { User.find_by(email: email) }

    let(:headers) do
      {
        'Accept'       => 'application/json',
        'Content-Type' => 'application/json',
        'Jwt-Auth'     => 'user_web_client'
      }
    end

    before do
      create_user(email, password)
    end

    context 'with a correct email and password' do
      let(:params) do
        {
          'user' => {
            'email'    => email,
            'password' => password
          }
        }.to_json
      end

      it 'logs the user in' do
        post(user_session_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(201)
        expect(response.content_type).to include('application/json')
        expect(response.headers).to include('Authorization')
        expect(parsed_body.keys).to include('id', 'email')
        expect(parsed_body['email']).to eq(email)
        expect(user.reload.logged_in?).to be_truthy
      end

      context 'when the user has items from a guest session in their cart' do
        let(:item) { @business_1.menu_items.first }

        before do
          create_businesses
          post(carted_items_path, :params => { 'menu_item_id' => item.id }.to_json, :headers => headers)
        end

        it 'logs the user in and moves the guest items to the user cart' do
          post(user_session_path, :params => params, :headers => headers)
          parsed_body = JSON.parse(response.body)
          expect(response.status).to eq(201)
          expect(response.content_type).to include('application/json')
          expect(response.headers).to include('Authorization')
          expect(parsed_body.keys).to include('id', 'email')
          expect(parsed_body['email']).to eq(email)
          expect(user.reload.logged_in?).to be_truthy
          expect(CartedItem.last.guest_user_id).to eq(nil)
          expect(CartedItem.last.user_id).to eq(user.id)
        end
      end
    end

    context 'with correct email and incorrect password' do
      let(:params) do
        {
          'user' => {
            'email'    => email,
            'password' => 'bad_password'
          }
        }.to_json
      end

      it 'fails to log the user in' do
        post(user_session_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(response.content_type).to include('application/json')
        expect(response.headers).not_to include('Authorization')
        expect(parsed_body.keys).not_to include('id', 'email')
        expect(parsed_body.keys).to include('error')
        expect(user.reload.logged_in?).to be_falsey
      end
    end

    context 'with correct email and incorrect password' do
      let(:params) do
        {
          'user' => {
            'email'    => 'bad_email',
            'password' => password
          }
        }.to_json
      end

      it 'fails to log the user in' do
        post(user_session_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(response.content_type).to include('application/json')
        expect(response.headers).not_to include('Authorization')
        expect(parsed_body.keys).not_to include('id', 'email')
        expect(parsed_body.keys).to include('error')
        expect(user.reload.logged_in?).to be_falsey
      end
    end
  end

  describe '#destroy' do
    context 'with a logged in user' do
      let(:email)    { 'test@example.com' }
      let(:password) { 'password' }
      let(:user)     { User.find_by(email: email) }

      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json',
          'Authorization' => @jwt
        }
      end

      before { create_and_log_in_user(email, password) }

      it 'successfully logs the user out' do
        delete(destroy_user_session_path, :headers => headers)
        expect(response.status).to eq(204)
        expect(user.reload.logged_in?).to be_falsey
      end
    end
  end
end
