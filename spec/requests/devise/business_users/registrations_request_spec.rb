require 'rails_helper'

RSpec.describe 'BusinessUsers::RegistrationsController', type: :request do
  describe '#create' do
    let(:email)                 { 'test@example.com' }
    let(:password)              { 'password' }
    let(:password_confirmation) { 'password' }

    let(:headers) do
      {
        'Accept'       => 'application/json',
        'Content-Type' => 'application/json',
        'Jwt-Auth'     => 'business_web_client'
      }
    end

    let(:params) do
      {
        'business_user' => {
          'email'                 => email,
          'password'              => password,
          'password_confirmation' => password_confirmation
        }
      }.to_json
    end

    context 'with a valid email and password' do
      it 'creates and logs in the business user' do
        post(business_user_registration_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(201)
        expect(response.content_type).to include('application/json')
        expect(response.headers).to include('Authorization')
        expect(parsed_body.keys).to eq(BUSINESS_USER_KEYS)
        expect(parsed_body['email']).to eq(email)
        expect(BusinessUser.find(parsed_body['id']).logged_in?).to be_truthy
      end
    end

    context 'with an invalid password' do
      let(:password) { '1234' }

      it 'fails to create a business user' do
        post(business_user_registration_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).to include('errors')
        expect(parsed_body['errors'].keys).to include('password_confirmation', 'password')
      end
    end

    context 'with an invalid password confirmation' do
      let(:password_confirmation) { 'not_a_match' }

      it 'fails to create a business user' do
        post(business_user_registration_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).to include('errors')
        expect(parsed_body['errors'].keys).to include('password_confirmation')
      end
    end

    context 'with an invalid email' do
      let(:email) { 'test' }

      it 'fails to create a business user' do
        post(business_user_registration_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).to include('errors')
        expect(parsed_body['errors'].keys).to include('email')
      end
    end

    context 'with an email already in use' do
      before do
        create_business_user(email, password)
      end

      it 'fails to create a business user' do
        post(business_user_registration_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).to include('errors')
        expect(parsed_body['errors'].keys).to include('email')
        expect(BusinessUser.count).to eq(1)
      end
    end
  end
end
