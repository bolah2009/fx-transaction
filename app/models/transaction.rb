class Transaction < ApplicationRecord
  default_scope { order('created_at ASC') }

  validates :customer, :input_amount, :input_currency, :output_amount, :output_currency, presence: true
  validates :customer, format: { with: FX::Regex::Transaction.customer_regex,
                                 message: 'only allows 3 to 5 alphanumerics' }
  validates :input_currency, :output_currency, format: { with: FX::Regex::Transaction.currency_regex,
                                                         message: 'only allows 3 upper case letters (alpha codes)' }
  validate :amount_format

  private

  def amount_format
    %i[input_amount output_amount].each do |amount|
      before_type_cast_amount = read_attribute_before_type_cast(amount).to_s
      next if before_type_cast_amount&.match?(FX::Regex::Transaction.amount_regex)

      errors.add(amount, 'must be 8 digits number with 2 decimal places')
    end
  end
end
