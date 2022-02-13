# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# creates 10 transactions
transactions = [
  {
    customer: SecureRandom.alphanumeric(4),
    input_amount: '444032.02', input_currency: 'NGN',
    output_amount: '3444.1', output_currency: 'GBP'
  },
  {
    customer: SecureRandom.alphanumeric(4),
    input_amount: '0.02', input_currency: 'CLF',
    output_amount: '3674.21', output_currency: 'GHS'
  },
  {
    customer: SecureRandom.alphanumeric(4),
    input_amount: '1.1', input_currency: 'SAR',
    output_amount: '3129034.10', output_currency: 'AED'
  },
  {
    customer: SecureRandom.alphanumeric(4),
    input_amount: '4444512.2', input_currency: 'USD',
    output_amount: '34554.21', output_currency: 'TRY'
  },
  {
    customer: SecureRandom.alphanumeric(4),
    input_amount: '90445332.29', input_currency: 'XAF',
    output_amount: '0.1', output_currency: 'ZAR'
  }

]

Transaction.create(transactions)
