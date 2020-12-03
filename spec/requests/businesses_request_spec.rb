require 'rails_helper'

RSpec.describe 'Businesses', type: :request do
  describe '#index' do
    let(:headers) do
      {
        'Accept'        => 'application/json',
        'Content-Type'  => 'application/json'
      }
    end

    before { create_businesses }

    it 'returns a list of businesses' do
      get(businesses_path, :headers => headers)
      parsed_body = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')
      expect(parsed_body).to be_an_instance_of(Array)
      expect(parsed_body.length).to eq(2)
      expect(parsed_body.first.keys).to eq(BUSINESSES_KEYS)
    end
  end

  describe '#show' do
    let(:headers) do
      {
        'Accept'        => 'application/json',
        'Content-Type'  => 'application/json'
      }
    end

    context 'when the business exists' do
      before { create_businesses }

      it 'returns a list of businesses' do
        get(business_path(@business_1.slug), :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(response.content_type).to include('application/json')

        # Check Businesses
        expect(parsed_body).to be_an_instance_of(Hash)
        expect(parsed_body.keys).to eq(BUSINESS_KEYS)
        expect(parsed_body['id']).to eq(@business_1.id)

        # Check Menus
        expect(parsed_body['menus']).to be_an_instance_of(Array)
        menu = parsed_body['menus'].first
        expect(menu).to be_an_instance_of(Hash)
        expect(menu.keys).to eq(MENU_KEYS)

        # Check MenuSections
        expect(menu['menu_sections']).to be_an_instance_of(Array)
        menu_section = menu['menu_sections'].first
        expect(menu_section).to be_an_instance_of(Hash)
        expect(menu_section.keys).to eq(MENU_SECTION_KEYS)

        # Check MenuItems
        expect(menu_section['menu_items']).to be_an_instance_of(Array)
        menu_item = menu_section['menu_items'].first
        expect(menu_item).to be_an_instance_of(Hash)
        expect(menu_item.keys).to eq(MENU_ITEM_KEYS)
      end
    end

    context 'when the business does not exist' do
      it 'receives an error message' do
        get(business_path('bad_slug'), :headers => headers)
        parsed_body = JSON.parse(response.body)
        expect(response.status).to eq(404)
        expect(response.content_type).to include('application/json')
        expect(parsed_body.keys).to include('error')
      end
    end
  end
end
