require 'swagger_helper'
# require 'rails_helper'

describe 'Transaction API', type: :request do
  path '/transactions' do
    post 'Creates a transaction' do
      tags 'Transactions'
      description ' Creates a transaction'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          customer: { type: :string },
          input_amount: { type: :string },
          input_currency: { type: :string },
          output_amount: { type: :string },
          output_currency: { type: :string }
        },
        required: %w[customer input_amount input_currency output_amount output_currency]
      }

      response '201', 'transaction created' do
        let(:transaction) { attributes_for(:transaction) }
        run_test!
      end

      response '422', 'invalid request' do
        let(:transaction) { attributes_for(:transaction, input_amount: '65757.86868') }

        run_test! do |response|
          error = JSON.parse(response.body)
          expect(error['input_amount']).to include 'must be 8 digits number with 2 decimal places'
        end
      end
    end

    get 'Retrieves all transactions' do
      tags 'Transactions'
      description ' Retrieves all transactions'
      produces 'application/json'

      response '200', 'transactions found' do
        schema type: :array,
               properties: [{
                 id: { type: :string },
                 customer: { type: :string },
                 input_amount: { type: :string },
                 input_currency: { type: :string },
                 output_amount: { type: :string },
                 output_currency: { type: :string }
               }],
               required: %w[customer input_amount input_currency output_amount output_currency]

        let(:transaction) { create_list(:transaction, 5) }
        run_test!
      end
    end
  end

  path '/transactions/{id}' do
    get 'Retrieves a transaction' do
      tags 'Transaction'
      description ' Retrieves a transaction'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'transaction found' do
        schema type: :object,
               properties: {
                 id: { type: :string },
                 customer: { type: :string },
                 input_amount: { type: :string },
                 input_currency: { type: :string },
                 output_amount: { type: :string },
                 output_currency: { type: :string }
               },
               required: %w[customer input_amount input_currency output_amount output_currency]

        let(:transaction) { create(:transaction) }
        let(:id) { transaction.id }
        run_test!
      end

      response '404', 'transaction not found' do
        let(:id) { 'invalid' }
        run_test! do |response|
          error_message = JSON.parse(response.body)['error']['message']
          expect(error_message).to eq "Couldn't find Transaction with 'id'=#{id}"
        end
      end
    end
  end
end
