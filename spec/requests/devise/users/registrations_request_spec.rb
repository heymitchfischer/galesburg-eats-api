require 'rails_helper'

RSpec.describe 'Devise::Registrations', type: :request do
  describe '#create' do
    let(:email)                 { 'test@example.com' }
    let(:password)              { 'password' }
    let(:password_confirmation) { 'password' }

    let(:headers) do
      {
        'Accept'       => 'application/json',
        'Content-Type' => 'application/json',
        'Jwt-Auth'     => 'user_web_client'
      }
    end

    let(:params) do
      {
        'user' => {
          'email'                 => email,
          'password'              => password,
          'password_confirmation' => password_confirmation
        }
      }.to_json
    end

    context 'with a valid email and password' do
      it 'creates and logs in the user' do
        post(user_registration_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(201)
        expect(response.content_type).to include('application/json')
        expect(response.headers).to include('Authorization')
        expect(parsed_body.keys).to include('id', 'email')
        expect(parsed_body['email']).to eq(email)
        expect(User.find(parsed_body['id']).logged_in?).to be_truthy
      end
    end

    context 'with an invalid password confirmation' do
      let(:password_confirmation) { 'not_a_match' }

      it 'fails to create a user' do
        post(user_registration_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).to include('errors')
        expect(parsed_body['errors'].keys).to include('password_confirmation')
      end
    end

    context 'with an invalid email' do
      let(:email) { 'test' }

      it 'fails to create a user' do
        post(user_registration_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).to include('errors')
        expect(parsed_body['errors'].keys).to include('email')
      end
    end

    context 'with an email already in use' do
      before do
        create_user(email, password)
      end

      it 'fails to create a user' do
        post(user_registration_path, :params => params, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).to include('errors')
        expect(parsed_body['errors'].keys).to include('email')
        expect(User.count).to eq(1)
      end
    end
  end
end
