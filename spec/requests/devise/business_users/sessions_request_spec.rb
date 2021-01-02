require 'rails_helper'

RSpec.describe 'BusinessUsers::SessionsController', type: :request do
  describe '#create' do
    let(:email)         { 'test@example.com' }
    let(:password)      { 'password' }
    let(:business_user) { BusinessUser.find_by(email: email) }

    let(:headers) do
      {
        'Accept'       => 'application/json',
        'Content-Type' => 'application/json',
        'Jwt-Auth'     => 'business_web_client'
      }
    end

    before do
      create_business_user(email, password)
    end

    context 'with a correct email and password' do
      let(:params) do
        {
          'business_user' => {
            'email'    => email,
            'password' => password
          }
        }.to_json
      end

      it 'logs the business user in' do
        post(business_user_session_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(201)
        expect(response.content_type).to include('application/json')
        expect(response.headers).to include('Authorization')
        expect(parsed_body.keys).to eq(BUSINESS_USER_KEYS)
        expect(parsed_body['email']).to eq(email)
        expect(business_user.reload.logged_in?).to be_truthy
      end
    end

    context 'with correct email and incorrect password' do
      let(:params) do
        {
          'business_user' => {
            'email'    => email,
            'password' => 'bad_password'
          }
        }.to_json
      end

      it 'fails to log the business user in' do
        post(business_user_session_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(response.content_type).to include('application/json')
        expect(response.headers).not_to include('Authorization')
        expect(parsed_body.keys).to include('error')
        expect(business_user.reload.logged_in?).to be_falsey
      end
    end

    context 'with correct email and incorrect password' do
      let(:params) do
        {
          'business_user' => {
            'email'    => 'bad_email',
            'password' => password
          }
        }.to_json
      end

      it 'fails to log the business user in' do
        post(business_user_session_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(response.content_type).to include('application/json')
        expect(response.headers).not_to include('Authorization')
        expect(parsed_body.keys).to include('error')
        expect(business_user.reload.logged_in?).to be_falsey
      end
    end
  end

  describe '#destroy' do
    context 'with a logged in business user' do
      let(:email)         { 'test@example.com' }
      let(:password)      { 'password' }
      let(:business_user) { BusinessUser.find_by(email: email) }

      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json',
          'Authorization' => @jwt
        }
      end

      before { create_and_log_in_business_user(email, password) }

      it 'successfully logs the business user out' do
        delete(destroy_business_user_session_path, :headers => headers)
        expect(response.status).to eq(204)
        expect(business_user.reload.logged_in?).to be_falsey
      end
    end
  end
end
