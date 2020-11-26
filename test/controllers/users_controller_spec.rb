require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  describe '#auto_sign_in' do
    context 'with a logged in user' do
      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json',
          'Authorization' => @jwt,
          'Jwt-Auth'      => 'user_web_client'
        }
      end

      before { create_and_log_in_user('test@example.com', 'password') }

      it 'successfully authenticates the user' do
        get(user_auto_sign_in_path, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(201)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).to include('id', 'email')
      end
    end

    context 'with a user that is not logged in' do
      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json',
          'Authorization' => "Bearer 12345",
          'Jwt-Auth'      => 'user_web_client'
        }
      end

      it 'fails to authenticate the user' do
        get(user_auto_sign_in_path, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).not_to include('id', 'email')
        expect(parsed_body.keys).to include('error')
      end
    end
  end
end
