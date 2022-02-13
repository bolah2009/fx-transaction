require 'swagger_helper'

describe 'Transaction API', type: :request do
  let(:json_response) { JSON.parse(response.body) }

  path '/transactions' do
    post 'Creates a new transaction' do
      tags 'POST /transactions:'
      description 'create a new transaction'
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
        example: {
          customer: SecureRandom.alphanumeric(5),
          input_amount: '4032.02',
          input_currency: 'NGN',
          output_amount: '34.21',
          output_currency: 'EUR'
        },
        required: %w[customer input_amount input_currency output_amount output_currency]
      }

      response '201', 'transaction created successfully<br>\
                      returns newly created transaction as json' do
        examples 'application/json' => {
          id: SecureRandom.uuid,
          customer: SecureRandom.alphanumeric(5),
          input_amount: '4032.02',
          input_currency: 'NGN',
          output_amount: '34.21',
          output_currency: 'EUR',
          created_at: Time.zone.now,
          updated_at: Time.zone.now
        }

        let(:transaction) { attributes_for(:transaction) }

        run_test! do |_response|
          expect(json_response['customer']).to eq transaction[:customer]
          expect(json_response['input_amount']).to eq transaction[:input_amount]
          expect(json_response['input_currency']).to eq transaction[:input_currency]
          expect(json_response['output_amount']).to eq transaction[:output_amount]
          expect(json_response['output_currency']).to eq transaction[:output_currency]
        end
      end

      response '422', 'invalid request' do
        examples 'application/json' => {
          customer: ['only allows 3 to 5 alphanumerics'],
          input_amount: ['must be 8 digits number with 2 decimal places'],
          input_currency: ['only allows 3 upper case letters (alpha codes)'],
          output_amount: ['must be 8 digits number with 2 decimal places'],
          output_currency: ['only allows 3 upper case letters (alpha codes)']
        }

        let(:transaction) do
          attributes_for(:transaction,
                         customer: 'invalid customer',
                         input_amount: '4032.86868',
                         input_currency: 'naira',
                         output_amount: '33385959324257.44',
                         output_currency: 'dollar')
        end
        run_test! do |_response|
          expect(json_response['customer']).to include 'only allows 3 to 5 alphanumerics'
          expect(json_response['input_amount']).to include 'must be 8 digits number with 2 decimal places'
          expect(json_response['input_currency']).to include 'only allows 3 upper case letters (alpha codes)'
          expect(json_response['output_amount']).to include 'must be 8 digits number with 2 decimal places'
          expect(json_response['output_currency']).to include 'only allows 3 upper case letters (alpha codes)'
        end
      end

      response '415', 'return an Unsupported Media Type error when invalid media type is supplied' do
        examples 'application/json' => {
          error: {
            message: 'Request data not supported, check your header content type'
          }
        }

        let(:transaction) { attributes_for(:transaction) }
        let(:'Content-Type') { 'application/foo' }

        run_test! do |_response|
          error_message = 'Request data not supported, check your header content type'
          expect(json_response['error']['message']).to eq error_message
        end
      end
    end

    get 'Retrieves all transactions' do
      tags 'GET /transactions:'
      description 'list all transactions in the system'
      produces 'application/json'

      response '200',
               "returns an array of transactions when found. <br>\
               It returns an empty array when there's no transaction found" do
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

        examples 'application/json' => [
          {
            id: '4e51389e-c78a-4c18-baea-6cd41911c6f0',
            customer: 'drf34',
            input_amount: '4000.01',
            input_currency: 'NGN',
            output_amount: '423.42',
            output_currency: 'EUR',
            created_at: '2022-02-12T20:46:53.997Z',
            updated_at: '2022-02-12T20:46:53.997Z'
          },
          { id: '...' }
        ]

        let!(:transaction) { create_list(:transaction, 5) }

        run_test! do |_response|
          expect(json_response.count).to eq 5
        end
      end
    end
  end

  path '/transactions/{id}' do
    get 'Retrieves a transaction' do
      tags 'GET /transactions/<id>:'
      description 'get the specific transaction by ID'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string,
                description: 'This is an id of an existing transaction with uuid format'

      response '200', 'returns a transaction with the following example and schema' do
        schema type: :object,
               properties: {
                 id: { type: :string },
                 customer: { type: :string },
                 input_amount: { type: :string },
                 input_currency: { type: :string },
                 output_amount: { type: :string },
                 output_currency: { type: :string },
                 created_at: { type: :datetime },
                 updated_at: { type: :datetime }
               },
               required: %w[customer input_amount input_currency output_amount output_currency created_at updated_at]

        examples 'application/json' => {
          id: SecureRandom.uuid,
          customer: SecureRandom.alphanumeric(5),
          input_amount: '4032.02',
          input_currency: 'NGN',
          output_amount: '34.21',
          output_currency: 'EUR',
          created_at: Time.zone.now,
          updated_at: Time.zone.now
        }

        let(:transaction) { create(:transaction) }
        let(:id) { transaction.id }

        run_test! do |_response|
          expect(json_response['customer']).to eq transaction[:customer]
          expect(json_response['input_currency']).to eq transaction[:input_currency]
          expect(json_response['output_currency']).to eq transaction[:output_currency]
        end
      end

      response '404', 'returns a json object, with error message when transaction is not found' do
        schema type: :object,
               properties: {
                 error: { type: :object }
               }

        examples 'application/json' => {
          error: {
            message: "Couldn't find Transaction with 'id'=invalid"
          }
        }

        let(:id) { 'invalid' }
        run_test! do |_response|
          error_message = json_response['error']['message']
          expect(error_message).to eq "Couldn't find Transaction with 'id'=#{id}"
        end
      end
    end
  end
end
