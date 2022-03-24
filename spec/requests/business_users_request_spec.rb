require 'rails_helper'

RSpec.describe 'BusinessUsers', type: :request do
  describe '#auto_sign_in' do
    context 'with a logged in business user' do
      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json',
          'Authorization' => @jwt,
          'Jwt-Auth'      => 'business_web_client'
        }
      end

      before { create_and_log_in_business_user('test@example.com', 'password') }

      it 'successfully authenticates the business user' do
        get(business_user_auto_sign_in_path, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(201)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).to eq(BUSINESS_USER_KEYS)
      end
    end

    context 'with a business user that is not logged in' do
      let(:headers) do
        {
          'Accept'        => 'application/json',
          'Content-Type'  => 'application/json',
          'Authorization' => "Bearer 12345",
          'Jwt-Auth'      => 'business_web_client'
        }
      end

      it 'fails to authenticate the business user' do
        get(business_user_auto_sign_in_path, :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).to include('error')
      end
    end
  end
end
