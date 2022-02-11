module FX
  module Regex
    module Transaction
      def self.currency_regex
        @currency_regex ||= /\A[A-Z]{3}\z/
      end

      def self.amount_regex
        @amount_regex ||= /\A\d{1,8}\.\d{1,2}\z/
      end

      def self.customer_regex
        @customer_regex ||= /\A[a-zA-Z\d]{3,5}\z/
      end
    end
  end
end
