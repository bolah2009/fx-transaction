require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject(:transaction) { build(:transaction) }

  context 'with validations' do
    shared_examples 'a currency code' do
      it { is_expected.to validate_presence_of(attribute) }

      context 'with less than allowed characters' do
        it do
          expect(transaction)
            .not_to allow_values(*%w[US ng a 3g __])
            .for(attribute)
            .with_message('only allows 3 upper case letters (alpha codes)')
        end
      end

      context 'with more than allowed characters' do
        it do
          expect(transaction)
            .not_to allow_values(*%w[USSD dollar Naira 500NGN 20_dollars 50dollars NARIA])
            .for(attribute)
            .with_message('only allows 3 upper case letters (alpha codes)')
        end
      end

      context 'with invalid characters' do
        it do
          expect(transaction)
            .not_to allow_values(*%w[US4 8NG 999 500 ngn usd])
            .for(attribute)
            .with_message('only allows 3 upper case letters (alpha codes)')
        end
      end

      context 'with valid characters' do
        it do
          expect(transaction)
            .to allow_values(*%w[USD NGN EUR CAD])
            .for(attribute)
        end
      end
    end

    shared_examples 'an amount' do
      it { is_expected.to validate_presence_of(attribute) }

      context 'with non digit characters' do
        it do
          expect(transaction)
            .not_to allow_values(*%w[65s96.90 money amount.nn 300..00 444?3.00])
            .for(attribute)
            .with_message('must be 8 digits number with 2 decimal places')
        end
      end

      context 'with more than allowed characters' do
        it do
          expect(transaction)
            .not_to allow_values('203456532.00', 3_333_389_990.200, 344_553_232.56, '20345532.030')
            .for(attribute)
            .with_message('must be 8 digits number with 2 decimal places')
        end
      end

      context 'with invalid digits' do
        it do
          expect(transaction)
            .not_to allow_values(*%w[4529044 8.8999999 23.333333 280000.001])
            .for(attribute)
            .with_message('must be 8 digits number with 2 decimal places')
        end
      end

      context 'with valid digits' do
        it do
          expect(transaction)
            .to allow_values('1.00', 32.01, 556.4, 200_000.45, 300_000.00, '43409449.00')
            .for(attribute)
        end
      end
    end

    shared_examples 'a customer' do
      it { is_expected.to validate_presence_of(:customer) }

      context 'with less than allowed characters' do
        it do
          expect(transaction)
            .not_to allow_values(*%w[US ng s D a_ 3g gH])
            .for(attribute)
            .with_message(error_message)
        end
      end

      context 'with more than allowed characters' do
        it do
          expect(transaction)
            .not_to allow_values(*%w[yRO44WEjV XsZ_25wv Q6uFlW Pyk02f?])
            .for(attribute)
            .with_message(error_message)
        end
      end

      context 'with invalid characters' do
        it do
          expect(transaction)
            .not_to allow_values(*%w[Zq_tZ UH*7L 8@33 7?{Eh])
            .for(attribute)
            .with_message(error_message)
        end
      end

      context 'with valid characters' do
        it do
          expect(transaction)
            .to allow_values(*%w[sTz sT3 2jkR DzPo xqSZp VLR8J])
            .for(attribute)
        end
      end
    end

    context 'with input_currency' do
      let(:attribute) { :input_currency }

      it_behaves_like 'a currency code'
    end

    context 'with output_currency' do
      let(:attribute) { :output_currency }

      it_behaves_like 'a currency code'
    end

    context 'with input_amount' do
      let(:attribute) { :input_amount }

      it_behaves_like 'an amount'
    end

    context 'with output_amount' do
      let(:attribute) { :output_amount }

      it_behaves_like 'an amount'
    end

    context 'with customer' do
      let(:error_message) { 'only allows 3 to 5 alphanumerics' }
      let(:attribute) { :customer }

      it_behaves_like 'a customer'
    end
  end
end
