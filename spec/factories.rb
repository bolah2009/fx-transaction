FactoryBot.define do
  factory :transaction do
    id { SecureRandom.uuid }
    customer { SecureRandom.alphanumeric(5) }
    input_amount { '4000.01' }
    input_currency { 'NGN' }
    output_amount { '423.42' }
    output_currency { 'EUR' }
  end
end
