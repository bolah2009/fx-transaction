require 'rails_helper'

RSpec.describe '/transactions', type: :request do
  let(:valid_attributes) do
    attributes_for(:transaction)
  end

  let(:invalid_attributes) do
    attributes_for(:transaction, input_currency: 'invalid')
  end

  let(:json_response) { JSON.parse(response.body) }
  let(:path) { '/transactions' }

  describe 'GET /transactions' do
    let(:count) { 5 }
    let!(:transaction) { create(:transaction) }

    before do
      create_list(:transaction, count - 1)
      get path, as: :json
    end

    it 'respond with a success status' do
      expect(response).to have_http_status(:success)
    end

    it 'renders an array of transactions' do
      expect(json_response).to be_kind_of Array
    end

    it 'contains all transaction' do
      expect(json_response.count).to be count
    end

    it 'contains transaction' do
      expected_response = JSON.parse(transaction.to_json)
      expect(json_response).to include expected_response
    end
  end

  describe 'GET /transactions/{id}' do
    before { get path, as: :json }

    let(:path) { "/transactions/#{id}" }

    let(:transaction) { create(:transaction) }

    context 'with valid id' do
      let(:id) { transaction.id }

      it 'respond with a success status' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the transaction' do
        expected_response = JSON.parse(transaction.to_json)
        expect(json_response).to include expected_response
      end
    end

    context 'with invalid id' do
      let(:id) { 'invalid' }

      it 'respond with a not found status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'renders an error message' do
        expect(json_response['error']['message']).to eq "Couldn't find Transaction with 'id'=#{id}"
      end
    end
  end

  describe 'POST /transactions' do
    subject(:request) { post path, params:, as: :json }

    let(:params) { { transaction: attribute } }

    context 'with valid parameters' do
      let(:attribute) { valid_attributes }

      it 'creates a new Transaction' do
        expect { request }.to change(Transaction, :count).by(1)
      end

      it 'respond with a created status' do
        request
        expect(response).to have_http_status(:created)
      end

      it 'renders a JSON response with the new transaction' do
        request

        expect(response.content_type).to match(a_string_including('application/json'))
      end

      it 'show all required attributes' do
        request

        %w[customer input_amount output_amount input_currency output_currency].each do |attr|
          expect(json_response).to include(attr => attribute[attr.to_sym])
        end
      end
    end

    context 'with invalid parameters' do
      let(:attribute) { invalid_attributes }

      it 'does not create a new Transaction' do
        expect { request }.to change(Transaction, :count).by(0)
      end

      it 'respond with a unprocessable entity status' do
        request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      context 'when attributes are invalid' do
        before { request }

        context 'with invalid customer attribute' do
          let(:invalid_attributes) { attributes_for(:transaction, customer: 'aa') }

          it 'renders an error message' do
            error_message = 'only allows 3 to 5 alphanumerics'
            expect(json_response['customer']).to include error_message
          end
        end

        context 'with invalid input_amount attribute' do
          let(:invalid_attributes) { attributes_for(:transaction, input_amount: 'invalid') }

          it 'renders an error message' do
            error_message = 'must be 8 digits number with 2 decimal places'
            expect(json_response['input_amount']).to include error_message
          end
        end

        context 'with invalid output_amount attribute' do
          let(:invalid_attributes) { attributes_for(:transaction, output_amount: 'invalid') }

          it 'renders an error message' do
            error_message = 'must be 8 digits number with 2 decimal places'
            expect(json_response['output_amount']).to include error_message
          end
        end

        context 'with invalid input_currency attribute' do
          let(:invalid_attributes) { attributes_for(:transaction, input_currency: 'NG') }

          it 'renders an error message' do
            error_message = 'only allows 3 upper case letters (alpha codes)'
            expect(json_response['input_currency']).to include error_message
          end
        end

        context 'with invalid output_currency attribute' do
          let(:invalid_attributes) { attributes_for(:transaction, output_currency: 'US') }

          it 'renders an error message' do
            error_message = 'only allows 3 upper case letters (alpha codes)'
            expect(json_response['output_currency']).to include error_message
          end
        end
      end
    end
  end
end
